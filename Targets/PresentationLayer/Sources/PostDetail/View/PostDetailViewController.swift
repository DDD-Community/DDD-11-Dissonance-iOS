//
//  PostDetailViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import DesignSystem
import DomainLayer
import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class PostDetailViewController: BaseViewController<PostDetailReactor>, Coordinatable, Alertable {
  
  // MARK: - Properties
  weak var coordinator: PostDetailCoordinator?
  private let reportActionSheetSubject: PublishSubject<Void> = .init()
  private var postURL: String?
  
  private enum Metric {
    static let bottomShadowViewHeightRatio: Percent = 12.7%
    static let showMoreButtonHeightRatio: Percent = 57.4%
  }
  
  private let scrollView: UIScrollView = {
    let scrollView: UIScrollView = .init()
    scrollView.bounces = false
    scrollView.contentInsetAdjustmentBehavior = .never
    return scrollView
  }()
  
  // MARK: UI 컴포넌트
  private let navigationBar: MozipNavigationBar
  private let imageView: UIImageView = {
    let imageView: UIImageView = .init()
    imageView.backgroundColor = MozipColor.gray10
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true
    imageView.layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: 4, blur: 8, spread: 0)
    return imageView
  }()
  private let titleLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "제목")
  private let titleValueLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800)
  private let organizationLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "기관•단체")
  private let organizationValueLabel: MozipLabel = .init(style: .body4, color: MozipColor.gray500)
  private let recruitDateLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "모집 기간")
  private let recruitDateValueLabel: MozipLabel = .init(style: .body4, color: MozipColor.gray500)
  private let recruitJobLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "모집 대상")
  private let tagLabelAreaView: UIView = .init()
  private let activityDateLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "활동 기간")
  private let activityDateValueLabel: MozipLabel = .init(style: .body4, color: MozipColor.gray500)
  private let activityContentsLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "활동 내용")
  private let activityContentsValueTextView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.isSelectable = true
    textView.isScrollEnabled = false
    textView.dataDetectorTypes = .link
    textView.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
    textView.textColor = MozipColor.gray500
    return textView
  }()
  private let bottomShadowView: BottomShadowView = .init()
  private let showMoreButton: RectangleButton = .init(title: "지원하기", fontStyle: .heading1, titleColor: .white, backgroundColor: MozipColor.primary500)
  
  private let reportButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("이 공고 신고하기", for: .normal)
    button.setTitleColor(MozipColor.gray400, for: .normal)
    button.titleLabel?.font = MozipFontStyle.caption2.font
    button.setUnderline()
    return button
  }()
  
  private var alertController: UIAlertController {
    let alertController: UIAlertController = .init()
    
    let actions: [UIAlertAction] = [
      .makeAction(type: .postEdit, action: { [weak self] in 
        let originID = self?.reactor?.postID ?? .init()
        let originPost = self?.reactor?.currentState.post ?? .init()
        self?.coordinator?.pushEditView(id: originID, post: originPost) 
      }),
      
      .makeAction(type: .postDelete, action: { [weak self] in
        self?.presentAlert(type: .deletePost, rightButtonAction: { [weak self] in
          self?.reactor?.action.onNext(.didTapDeleteButton)
        })
      }),
      
      .makeAction(type: .postReport, action: { [weak self] in
        self?.reportActionSheetSubject.onNext(())
      }),
      
      .makeAction(type: .cancel)
    ]
    
    actions.forEach {
      alertController.addAction($0)
    }
    return alertController
  }
  
  private let shareButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(.init(systemName: "square.and.arrow.up"), for: .normal)
    button.tintColor = .black
    return button
  }()
  
  private let ellipsisButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(DesignSystemAsset.verticalEllipsisIcon.image, for: .normal)
    return button
  }()
  
  private let imageViewController: ImageViewController = {
    let vc = ImageViewController()
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .crossDissolve
    return vc
  }()
  
  // MARK: - Initializer
  init(reactor: PostDetailReactor) {
    navigationBar = .init(title: " ", backgroundColor: .white)
    navigationBar.setRightButtons([shareButton, ellipsisButton])
    super.init()
    
    self.reactor = reactor
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    coordinator?.disappear()
  }
  
  override func viewDidLayoutSubviews() {
    navigationBar.pin.top().left().right()
    bottomShadowView.pin.bottom().left().right().height(Metric.bottomShadowViewHeightRatio)
    showMoreButton.pin.top(12).horizontally(23).height(Metric.showMoreButtonHeightRatio)
    
    scrollView.pin.top(to: navigationBar.edge.bottom).left().right().bottom(to: bottomShadowView.edge.top)
    rootContainer.pin.top().left().right()
    rootContainer.flex.layout(mode: .adjustHeight)
    scrollView.contentSize = rootContainer.frame.size
  }
  
  // MARK: - Methods
  override func bind(reactor: PostDetailReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    super.setupViews()
    view.addSubview(scrollView)
    scrollView.addSubview(rootContainer)
    view.addSubview(bottomShadowView)
    bottomShadowView.addSubview(showMoreButton)
    view.addSubview(navigationBar)
    
    rootContainer.flex
      .define {
        $0.addItem(imageView).aspectRatio(1)
        
        $0.addItem()
          .marginHorizontal(20)
          .define {
            $0.addItem(titleLabel).marginTop(23)
            $0.addItem(titleValueLabel).marginTop(8)
            $0.addItem(organizationLabel).marginTop(23)
            $0.addItem(organizationValueLabel).marginTop(8)
            $0.addDivider().marginTop(24)
            $0.addItem(recruitDateLabel).marginTop(24)
            $0.addItem(recruitDateValueLabel).marginTop(8)
            $0.addItem(recruitJobLabel).marginTop(23)
            
            $0.addItem(tagLabelAreaView)
              .direction(.row)
              .wrap(.wrap)
              .alignContent(.spaceBetween)
            
            $0.addDivider().marginTop(24)
            $0.addItem(activityDateLabel).marginTop(24)
            $0.addItem(activityDateValueLabel).marginTop(8)
            $0.addItem(activityContentsLabel).marginTop(24)
            $0.addItem(activityContentsValueTextView).marginTop(8)
            $0.addItem(reportButton).marginTop(24).width(80).marginBottom(23)
          }
      }
  }
}

// MARK: - Private Extenion
private extension PostDetailViewController {
  
  // MARK: Properties
  typealias Action = PostDetailReactor.Action
  
  var postBinder: Binder<Post> {
    return .init(self) { owner, post in
      owner.postURL = post.postUrlString
      owner.navigationBar.setNavigationTitle(post.categoryTitle)
      owner.imageView.image = UIImage(data: post.imageData)
      owner.imageViewController.setImage(UIImage(data: post.imageData)!) // TODO: 추후 placeholder 이미지 적용
      owner.titleValueLabel.text = post.title
      owner.organizationValueLabel.text = post.organization
      owner.recruitDateValueLabel.text = post.recruitStartDate + " ~ " + post.recruitEndDate
      owner.addTagLabel(post.jobGroups)
      owner.activityDateValueLabel.text = post.activityStartDate + " ~ " + post.activityEndDate
      owner.activityContentsValueTextView.text = post.activityContents
      owner.updateLayout()
    }
  }
  
  // MARK: Methods
  func bindAction(reactor: PostDetailReactor) {
    rx.viewDidLoad
      .map { Action.fetchPost }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    imageView.rxGesture.tap
      .map { _ in Action.didTapImageView }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    imageViewController.dismissRelay
      .map { Action.dismissImageViewController }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    Observable.merge([reportButton.rx.tap.asObservable(), reportActionSheetSubject])
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, reportAction in
        if AppProperties.accessToken == .init() {
          owner.coordinator?.pushLoginPage()
          return
        }
        owner.presentAlert(type: .report, rightButtonAction: { owner.reactor?.action.onNext(.didTapReportButton) })
      })
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: PostDetailReactor) {
    reactor.state
      .map { $0.post }
      .filter { !$0.title.isEmpty }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(to: postBinder)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isDeleted }
      .filter { $0 }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.coordinator?.didFinish()
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isSuccessReport }
      .distinctUntilChanged()
      .filter { $0 }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.view.showToast(message: "신고가 성공적으로 접수되었습니다.")
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isErrorReport }
      .filter { $0.isError }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, errorState in
        owner.view.showToast(message: errorState.message)
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .filter { $0 }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        // TODO: 스켈레톤 적용
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isPresentFullImage)
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: false)
      .emit(with: self) { owner, isPresent in
        if isPresent {
          owner.present(owner.imageViewController, animated: true)
        } else {
          owner.dismiss(animated: true)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isFetchError }
      .filter { $0 }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.coordinator?.pushErrorView()
      })
      .disposed(by: disposeBag)
    
  }
  
  func bind() {
    navigationBar.backButtonTapObservable
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.coordinator?.didFinish()
      })
      .disposed(by: disposeBag)
    
    ellipsisButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.present(owner.alertController, animated: true)
      })
      .disposed(by: disposeBag)
    
    shareButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.showActivityController()
      })
      .disposed(by: disposeBag)
    
    showMoreButton.tapObservable
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        guard let reactor = owner.reactor else { return }
        owner.coordinator?.pushWebView(urlString: reactor.currentState.post.postUrlString)
      })
      .disposed(by: disposeBag)
  }
  
  func addTagLabel(_ jobGroups: [String]) {
    for jobGroup in jobGroups {
      let tagLabel: TagLabel = .init()
      tagLabel.text = "\(jobGroup)"
      
      tagLabelAreaView.flex.define {
        $0.addItem(tagLabel).marginTop(8).marginRight(8)
      }
    }
  }
  
  func updateLayout() {
    [titleValueLabel, organizationValueLabel, activityContentsValueTextView, rootContainer].forEach {
      $0.flex.layout(mode: .adjustHeight)
    }
    
    scrollView.contentSize = rootContainer.frame.size
  }
  
  func showActivityController() {
    let item = postURL ?? "공고 URL이 존재하지 않습니다."
    let activityVC = UIActivityViewController(
      activityItems: [item],
      applicationActivities: nil
    )
    self.present(activityVC, animated: true, completion: nil)
  }
}
