//
//  PostDetailViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import MozipCore
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
    static let bottomShadowViewHeightPercent: Percent = 12.7%
    static let bottomShadowViewHorizontalPadding: CGFloat = 23
    static let bookmarkButtonTopPadding: CGFloat = 11
    static let applyButtonLeftPadding: CGFloat = 16
    static let applyButtonHeightRatio: CGFloat = 0.574
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
  private let titleLabel: MozipLabel = .init(style: .heading1, color: MozipColor.gray800)
  private let organizationLabel: MozipLabel = .init(style: .body2, color: MozipColor.gray500)
  private let countView: ViewCountView = .init()
  private let recruitDateLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray400, text: "모집 기간")
  private let recruitDateValueLabel: MozipLabel = .init(style: .body2, color: MozipColor.gray700)
  private let recruitJobLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray400, text: "모집 대상")
  private let tagLabelAreaView: UIView = .init()
  private let activityDateContainer: UIView = .init()
  private let activityDateLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray400, text: "활동 기간")
  private let activityDateValueLabel: MozipLabel = .init(style: .body2, color: MozipColor.gray700)
  private let activityContentsLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray400, text: "활동 내용")
  private let activityContentsValueTextView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.isSelectable = true
    textView.isScrollEnabled = false
    textView.dataDetectorTypes = .link
    textView.font = DesignSystemFontFamily.Pretendard.regular.font(size: 16)
    textView.textColor = MozipColor.gray800
    textView.backgroundColor = MozipColor.gray10
    textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    return textView
  }()
  private let bottomShadowView: BottomShadowView = .init()
  private let bookmarkButton: BookmarkButton = .init()
  private let applyButton: RectangleButton = .init(
    title: "지원하기",
    fontStyle: .heading1,
    titleColor: .white,
    backgroundColor: MozipColor.primary500
  )
  private var alertController: UIAlertController { makeAlertController() }
  
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
  
  private var skeletonableViews: [UIView] {
    return [
      imageView, titleLabel, organizationLabel, countView, recruitDateLabel, recruitDateValueLabel, recruitJobLabel, 
      activityDateLabel, activityDateValueLabel, activityContentsLabel, activityContentsValueTextView
    ]
  }
  
  // MARK: - Initializer
  init(reactor: PostDetailReactor) {
    navigationBar = .init(title: " ", backgroundColor: .white)
    navigationBar.setRightButtons([shareButton, ellipsisButton])
    super.init()
    
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    coordinator?.disappear()
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    navigationBar.pin.top().left().right()
    bottomShadowView.pin.bottom().left().right().height(Metric.bottomShadowViewHeightPercent)
    
    let bookmarkButtonSize = bottomShadowView.frame.height * Metric.applyButtonHeightRatio
    bookmarkButton.pin.top(Metric.bookmarkButtonTopPadding).height(bookmarkButtonSize).width(bookmarkButtonSize)
      .left(Metric.bottomShadowViewHorizontalPadding)
    applyButton.pin.top(to: bookmarkButton.edge.top).height(bookmarkButtonSize)
      .left(to: bookmarkButton.edge.right).marginLeft(Metric.applyButtonLeftPadding)
      .right(Metric.bottomShadowViewHorizontalPadding)
    
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
    
    showAllSkeleton()
    view.addSubview(scrollView)
    scrollView.addSubview(rootContainer)
    view.addSubview(bottomShadowView)
    bottomShadowView.addSubview(bookmarkButton)
    bottomShadowView.addSubview(applyButton)
    view.addSubview(navigationBar)
    
    rootContainer.flex
      .define {
        // 썸네일 이미지뷰
        $0.addItem(imageView).aspectRatio(1)
        
        $0.addItem()
          .marginHorizontal(20)
          .define {
            // 제목
            $0.addItem(titleLabel).width(100).marginTop(24)
            
            // 모집 기관, 조회수
            $0.addItem()
              .direction(.row)
              .justifyContent(.spaceBetween)
              .marginTop(8)
              .define {
                $0.addItem(organizationLabel).width(100).shrink(1)
                $0.addItem(countView).width(50).marginLeft(16)
              }
            
            $0.addDivider(color: MozipColor.gray50).marginTop(16)
            
            // 모집 기간, 활동 기간
            $0.addItem()
              .marginTop(24)
              .define {
                $0.addItem()
                  .direction(.row)
                  .define {
                    $0.addItem(recruitDateLabel)
                    $0.addItem(recruitDateValueLabel).marginLeft(34).grow(1)
                  }
                
                $0.addItem(activityDateContainer)
                  .marginTop(8)
                  .direction(.row)
                  .define {
                    $0.addItem(activityDateLabel)
                    $0.addItem(activityDateValueLabel).marginLeft(34).grow(1)
                  }
              }
            
            // 모집 대상
            $0.addItem(recruitJobLabel).width(100).marginTop(32)
            $0.addItem(tagLabelAreaView)
              .direction(.row)
              .wrap(.wrap)
              .alignContent(.spaceBetween)
            
            // 활동 내용
            $0.addItem(activityContentsLabel).width(100).marginTop(32)
            $0.addItem(activityContentsValueTextView).marginTop(12).marginBottom(30).cornerRadius(8)
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
      owner.titleLabel.text = post.title
      owner.organizationLabel.text = post.organization
      owner.countView.setupCountLabel(post.viewCount)
      owner.recruitDateValueLabel.text = post.recruitStartDate + " ~ " + post.recruitEndDate
      owner.addTagLabel(post.jobGroups)
      
      if post.activityStartDate == "" && post.activityEndDate == "" {
        owner.updateActivityDateVisibility(false)
      } else {
        owner.activityDateValueLabel.text = post.activityStartDate + " ~ " + post.activityEndDate
      }
      
      owner.activityContentsValueTextView.text = post.activityContents
      owner.bookmarkButton.setBookmarked(post.isBookmarked)
      owner.hideAllSkeleton()
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
    
    reportActionSheetSubject
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, reportAction in
        if AppProperties.accessToken == .init() {
          owner.coordinator?.pushLoginPage()
          return
        }
        owner.presentAlert(type: .report, rightButtonAction: { owner.reactor?.action.onNext(.didTapReportButton) })
      })
      .disposed(by: disposeBag)
    
    bookmarkButton.rx.tap
      .map { Action.didTapBookmarkButton }
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self, onNext: { owner, bookmarkButtonAction in
        guard AppProperties.accessToken != .init() else {
          owner.coordinator?.pushLoginPage()
          return
        }
        
        reactor.action.onNext(bookmarkButtonAction)
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
      .map { $0.post }
      .filter { !$0.title.isEmpty }
      .map { $0.isBookmarked }
      .distinctUntilChanged()
      .skip(1)
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, isBookmarked in
        let toastMessage = isBookmarked ? "북마크를 설정하였습니다." : "북마크를 해제하였습니다."
        owner.bookmarkButton.setBookmarked(isBookmarked)
        owner.view.showToast(message: toastMessage)
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isDeleted }
      .filter { $0 }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.coordinator?.didFinish()
        owner.navigationController?.view.showToast(message: "공고를 삭제하였습니다.")
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
    coordinator?.childCompletedObservable
      .filter { [weak self] in self?.reactor?.currentState.post != $0 }
      .bind(with: self, onNext: { owner, post in
        owner.reactor?.action.onNext(.updatePost(post))
        owner.postBinder.onNext(post)
      })
      .disposed(by: disposeBag)
    
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
        GA.logEvent(.공유버튼)
        owner.showActivityController()
      })
      .disposed(by: disposeBag)
    
    applyButton.tapObservable
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        GA.logEvent(.지원하기버튼)
        guard let reactor = owner.reactor else { return }
        owner.coordinator?.pushWebView(urlString: reactor.currentState.post.postUrlString)
      })
      .disposed(by: disposeBag)
  }
  
  func addTagLabel(_ jobGroups: [String]) {
    tagLabelAreaView.subviews.forEach { $0.removeFromSuperview() }
    
    for jobGroup in jobGroups {
      let tagLabel: TagLabel = .init()
      tagLabel.text = "\(jobGroup)"
      
      tagLabelAreaView.flex.define {
        $0.addItem(tagLabel).marginTop(8).marginRight(8)
      }
    }
  }
  
  func updateLayout() {
    [titleLabel, organizationLabel, countView, recruitJobLabel, activityContentsLabel].forEach {
      $0.flex.width(nil)
    }
    
    [titleLabel, organizationLabel, recruitJobLabel, activityContentsLabel, activityContentsValueTextView].forEach {
      $0.flex.markDirty()
    }
    countView.markDirty()
    
    rootContainer.flex.layout(mode: .adjustHeight)
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
  
  func showAllSkeleton() {
    skeletonableViews.forEach {
      $0.showSkeleton()
    }
  }
  
  func hideAllSkeleton() {
    skeletonableViews.forEach {
      $0.hideSkeleton()
    }
  }
  
  func updateActivityDateVisibility(_ isVisible: Bool) {
    activityDateContainer.flex.display(isVisible ? .flex : .none)
    rootContainer.flex.layout()
  }

  func makeAlertController() -> UIAlertController {
    let alertController: UIAlertController = .init()
    
    var actions: [UIAlertAction] = [
      .makeAction(type: .postReport, action: { [weak self] in
        self?.reportActionSheetSubject.onNext(())
      }),
      .makeAction(type: .cancel)
    ]
    
    if AppProperties.isAdmin {
      let adminActions: [UIAlertAction] = [
        .makeAction(type: .postEdit, action: { [weak self] in 
          let originID = self?.reactor?.postID ?? .init()
          let originPost = self?.reactor?.currentState.post ?? .init()
          self?.coordinator?.pushEditView(id: originID, post: originPost) 
        }),
        .makeAction(type: .postDelete, action: { [weak self] in
          self?.presentAlert(type: .deletePost, rightButtonAction: { [weak self] in
            self?.reactor?.action.onNext(.didTapDeleteButton)
          })
        })
      ]
      
      actions = adminActions + actions
    }
    
    actions.forEach {
      alertController.addAction($0)
    }
    
    return alertController
  }
}
