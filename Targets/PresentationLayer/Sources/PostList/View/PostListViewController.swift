//
//  PostListViewController.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DesignSystem
import DomainLayer

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class PostListViewController: BaseViewController<PostListReactor>, Coordinatable {
  
  // MARK: Properties
  weak var coordinator: PostListCoordinator?
  private let postkind: PostKind
  private let orderRelay: BehaviorRelay<PostOrder> = .init(value: .latest)
  private let pageBottomRelay: PublishRelay<Void> = .init()
  
  private var categoryID: Int {
    postkind.id
  }
  
  // MARK: UI
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let jobCategoryView = JobCategoryView()
  private let postOrderControlView = PostOrderControlView()
  private let collectionView = PostListCollectionView()
  private let orderDropDownMenu = OrderDropDownMenu()
  
  private let navigationBar = MozipNavigationBar(
    title: "공모전",
    tintColor: MozipColor.gray900,
    backgroundColor: MozipColor.white
  )
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  // MARK: Initializer
  init(reactor: PostListReactor, postKind: PostKind) {
    self.postkind = postKind
    
    super.init()
    self.reactor = reactor
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    coordinator?.disappear()
  }
  
  // MARK: Overrides
  override func bind(reactor: PostListReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    super.setupViews()
    setupNavigationBar()
    setupInitialState()
  }
  
  override func viewDidLayoutSubviews() {
    setupViewLayout()
  }
  
  // MARK: Methods
  private func setupNavigationBar() {
    navigationBar.backButtonTapObservable
      .bind(with: self) { owner, _ in
        owner.coordinator?.didFinish()
      }
      .disposed(by: disposeBag)
  }
  
  private func setupInitialState() {
    orderDropDownMenu.alpha = 0
    navigationBar.setNavigationTitle(postkind.navigationTitle)
  }
}

// MARK: - Private Extenion
private extension PostListViewController {
  
  // MARK: Properties
  typealias Action = PostListReactor.Action
  typealias State = PostListReactor.State
  
  // MARK: Methods
  func bindAction(reactor: PostListReactor) {
    rx.viewWillAppear
      .withUnretained(self)
      .map { owner, _ in owner.recentSearchParameter() }
      .map(Action.fetchPosts)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    collectionView.cellTapObservable
      .asSignal(onErrorJustReturn: IndexPath())
      .map { Action.tapCell(indexPath: $0) }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
    
    postOrderControlView.isOrderButtonTappedRelay
      .asSignal(onErrorJustReturn: false)
      .emit(with: self) { owner, bool in
        UIView.animate(withDuration: 0.3) {
          owner.updateOrderMenuLayout(bool)
        }
        owner.view.setNeedsLayout()
      }
      .disposed(by: disposeBag)
    
    orderDropDownMenu.isLatestOrder
      .map { $0 ? .latest : .deadline }
      .bind(with: self) { owner, order in
        owner.orderRelay.accept(order)
        owner.postOrderControlView.setOrder(order)
        owner.postOrderControlView.isOrderButtonTappedRelay.accept(false)
      }
      .disposed(by: disposeBag)
    
    scrollView.rx.contentOffset
      .skip(1)
      .withUnretained(self)
      .throttle(.milliseconds(500),latest: false, scheduler: MainScheduler.instance)
      .subscribe(onNext: { owner, offset in
        let scrollView = owner.scrollView
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        let yOffset = offset.y
        if yOffset + scrollViewHeight >= contentHeight - 100 {
          owner.pageBottomRelay.accept(())
        }
      })
      .disposed(by: disposeBag)
    
    pageBottomRelay
      .withUnretained(self)
      .map { owner, _ in owner.recentSearchParameter() }
      .map(Action.fetchNextPage)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    if postkind == .contest {
      Observable.combineLatest(
        orderRelay,
        jobCategoryView.selectionRelay
      )
      .distinctUntilChanged { previous, current in
        let (previousOrder, previousCategory) = previous
        let (currentOrder, currentCategory) = current
        return previousOrder == currentOrder && previousCategory == currentCategory
      }
      .withUnretained(self)
      .map { owner, args in
        owner.scrollView.setContentOffset(.zero, animated: true)
        let (order, category) = args
        let id = category.id
        return Action.fetchPosts(id: id, order: order)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    } else {
      orderRelay
        .distinctUntilChanged()
        .withUnretained(self)
        .map { owner, order in
          return Action.fetchPosts(id: owner.categoryID, order: order)
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
  }
  
  func bindState(reactor: PostListReactor) {
    reactor.state
      .map { $0.posts }
      .distinctUntilChanged()
      .filter { !$0.isEmpty }
      .asSignal(onErrorJustReturn: [])
      .emit(with: self) { owner, posts in
        owner.collectionView.setupData(posts)
        owner.collectionView.flex.markDirty()
        owner.contentView.flex.layout(mode: .adjustHeight)
        owner.scrollView.contentSize.height = owner.contentView.frame.size.height
        owner.postOrderControlView.setCount(posts.count)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.selectedCell }
      .asSignal(onErrorJustReturn: .stub())
      .emit(with: self) { owner, cell in
        owner.coordinator?.pushPostDetail(id: cell.id)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: false)
      .emit { isLoading in
        isLoading ? LoadingIndicator.start(withDimming: false) : LoadingIndicator.stop()
      }
      .disposed(by: disposeBag)
  }
  
  private func recentSearchParameter() -> (Int, PostOrder) {
    let order = orderDropDownMenu.isLatestOrder.value ? PostOrder.latest : PostOrder.deadline
    
    if postkind == .contest {
      let selectionId = jobCategoryView.selectionRelay.value.id
      return (selectionId, order)
    } else {
      return (categoryID, order)
    }
  }
}

// MARK: - Layout
private extension PostListViewController {
  func setupViewHierarchy() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    scrollView.addSubview(orderDropDownMenu)
    if postkind == .contest {
      view.addSubview(jobCategoryView)
    }
    view.addSubview(navigationBar)
    
    contentView.flex
      .direction(.column)
      .justifyContent(.start)
      .define { flex in
        flex.addItem().width(100%).height(8).backgroundColor(MozipColor.gray10)
        flex.addItem(postOrderControlView)
        flex.addItem(collectionView)
      }
  }
  
  func setupViewLayout() {
    navigationBar.pin.top().left().right().sizeToFit(.content)
    if postkind == .contest {
      jobCategoryView.pin.top(to: navigationBar.edge.bottom).left().right().sizeToFit().marginTop(10)
      scrollView.pin.left().right().bottom().top(to: jobCategoryView.edge.bottom)
    } else {
      scrollView.pin.left().right().bottom().top(to: navigationBar.edge.bottom)
    }
    contentView.pin.top().left().right()
    contentView.flex.layout(mode: .adjustHeight)
    scrollView.contentSize = contentView.frame.size
    collectionView.flex.markDirty()
    navigationBar.layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: 4, blur: 8, spread: 0)
    jobCategoryView.layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: 4, blur: 8, spread: 0)
    updateOrderMenuLayout(postOrderControlView.isOrderButtonTappedRelay.value)
  }
  
  func updateOrderMenuLayout(_ isTapped: Bool) {
    if isTapped {
      orderDropDownMenu.pin
        .topRight(to: postOrderControlView.anchor.bottomRight)
        .right()
        .marginRight(20)
      orderDropDownMenu.alpha = 1
    } else {
      orderDropDownMenu.pin
        .topRight(to: postOrderControlView.anchor.bottomRight)
        .right()
        .marginRight(20)
        .marginTop(-10)
      orderDropDownMenu.alpha = 0
    }
  }
}
