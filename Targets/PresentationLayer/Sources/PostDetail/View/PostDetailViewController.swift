//
//  PostDetailViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DesignSystem
import DomainLayer
import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class PostDetailViewController: BaseViewController<PostDetailReactor>, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: PostDetailCoordinator?
  
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
    imageView.layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: 4, blur: 8, spread: 0)
    return imageView
  }()
  private let titleLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "제목")
  private let titleValueLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800)
  private let organizationLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "기관•단체")
  private let organizationValueLabel: MozipLabel = .init(style: .body4, color: MozipColor.gray500)
  private let recruitDateLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "모집 기간")
  private let recruitDateValueLabel: MozipLabel = .init(style: .body4, color: MozipColor.gray500)
  private let recruitJobLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "모집 직군")
  private let tagLabelAreaView: UIView = .init()
  private let activityDateLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "활동 기간")
  private let activityDateValueLabel: MozipLabel = .init(style: .body4, color: MozipColor.gray500)
  private let activityContentsLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "활동 내용")
  private let activityContentsValueLabel: MozipLabel = .init(style: .body4, color: MozipColor.gray500)
  private let bottomShadowView: BottomShadowView = .init()
  private let showMoreButton: RectangleButton = .init(title: "자세히 보기", fontStyle: .heading1, titleColor: .white, backgroundColor: MozipColor.primary500)
  
  private let reportButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("이 공고 신고하기", for: .normal)
    button.setTitleColor(MozipColor.gray400, for: .normal)
    button.titleLabel?.font = MozipFontStyle.caption2.font
    button.setUnderline()
    return button
  }()
  
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
  
  // MARK: - Initializer
  init(categoryTitle: String, reactor: PostDetailReactor) {
    navigationBar = .init(title: categoryTitle, backgroundColor: .white)
    navigationBar.setRightButtons([shareButton, ellipsisButton])
    super.init()
    
    self.reactor = reactor
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
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
            $0.addItem(activityContentsValueLabel).marginTop(8)
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
      owner.imageView.image = UIImage(data: post.imageData)
      owner.titleValueLabel.text = post.title
      owner.organizationValueLabel.text = post.organization
      owner.recruitDateValueLabel.text = post.recruitStartDate + "~" + post.recruitEndDate
      owner.addTagLabel(post.jobGroups)
      owner.activityDateValueLabel.text = post.activityStartDate + "~" + post.activityEndDate
      owner.activityContentsValueLabel.text = post.activityContents
    }
  }
  
  // MARK: Methods
  func bindAction(reactor: PostDetailReactor) {
    rx.viewDidLoad
      .map { Action.fetchData }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reportButton.rx.tap
      .map { Action.didTapReportButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: PostDetailReactor) {
    reactor.state
      .map { $0.post }
      .asSignal(onErrorSignalWith: .empty())
      .emit(to: postBinder)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isSuccessReport }
      .filter { $0 }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        // TODO: 토스트 팝업
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
  }
  
  func addTagLabel(_ jobGroups: [(job: String, count: Int)]) {
    for jobGroup in jobGroups {
      let tagLabel: TagLabel = .init()
      tagLabel.text = "\(jobGroup.job) • \(jobGroup.count)명"
      
      tagLabelAreaView.flex.define {
        $0.addItem(tagLabel).height(36).marginTop(8).marginRight(8)
      }
    }
  }
}