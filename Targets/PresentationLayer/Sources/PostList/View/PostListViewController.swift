//
//  PostListViewController.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DesignSystem

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class PostListViewController: BaseViewController<PostListReactor>, Coordinatable {
  
  enum PostKind: String, CaseIterable {
    case 공모전 = "공모전 📑"
    case 해커톤 = "해커톤 🏆"
    case 동아리 = "IT 동아리 💻"
    
    var title: String {
      switch self {
      case .공모전: "공모전"
      case .해커톤: "해커톤"
      case .동아리: "동아리"
      }
    }
  }
  
  // MARK: Properties
  weak var coordinator: PostListCoordinator?
  private let postkind: PostKind
  
  // MARK: UI
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let jobCategoryView = JobCategoryView()
  private let postOrderControlView = PostOrderControlView()
  private let collectionView = PostListCollectionView()
  private let postListSkeleton = PostListSkeleton()
  
  private let navigationBar = MozipNavigationBar(
    title: "공모전",
    tintColor: .white,
    backgroundColor: MozipColor.primary500
  )
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: Initializer
  init(reactor: PostListReactor, code: String) {
    self.postkind = PostKind.init(rawValue: code) ?? .공모전
    
    super.init()
    self.reactor = reactor
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: LifeCycle
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
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
    bind()
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
    scrollView.alpha = 0
    navigationBar.setNavigationTitle(postkind.title)
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
      .map { owner, _ in Int(PostKind.allCases.firstIndex(of: owner.postkind) ?? .zero) + 1 }
      .map { Action.fetchPosts(id: $0, order: .latest) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    collectionView.cellTapObservable
      .asSignal(onErrorJustReturn: IndexPath())
      .map { Action.tapCell(indexPath: $0) }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
    
    if postkind == .공모전 {
      Observable.combineLatest(
        postOrderControlView.orderRelay,
        jobCategoryView.selectionRelay
      )
      .distinctUntilChanged { previous, current in
        let (previousOrder, previousCategory) = previous
        let (currentOrder, currentCategory) = current
        return previousOrder == currentOrder && previousCategory == currentCategory
      }
      .withUnretained(self)
      .map { owner, args in
        let (order, category) = args
        let id = category.id
        return Action.fetchPosts(id: id, order: order)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    } else {
      postOrderControlView.orderRelay
        .distinctUntilChanged()
        .withUnretained(self)
        .map { owner, order in
          let id = Int(PostKind.allCases.firstIndex(of: owner.postkind) ?? .zero) + 1
          return Action.fetchPosts(id: id, order: order)
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
  }
  
  func bindState(reactor: PostListReactor) {
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .take(2)
      .asSignal(onErrorJustReturn: false)
      .emit(with: self, onNext: { owner, isLoading in
        if isLoading {
          // TODO: 추후 로딩화면 Skeleton 적용
        } else {
          UIView.animate(withDuration: 0.5) {
            owner.scrollView.alpha = 1
          }
          owner.postListSkeleton.hide()
        }
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.posts }
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: [])
      .emit(with: self) { owner, posts in
        owner.collectionView.setupData(posts)
        owner.collectionView.pin.sizeToFit()
        owner.scrollView.contentSize.height = owner.collectionView.sizeThatFits(.zero).height + owner.postOrderControlView.frame.height
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
  }
  
  private func bind() {
    
  }
}

// MARK: - Layout
private extension PostListViewController {
  func setupViewHierarchy() {
    view.addSubview(navigationBar)
    if postkind == .공모전 {
      view.addSubview(jobCategoryView)
    }
    view.addSubview(postListSkeleton)
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    contentView.flex.direction(.column).justifyContent(.start).define { flex in
      flex.addItem(postOrderControlView)
      flex.addItem(collectionView)
    }
  }
  
  func setupViewLayout() {
    navigationBar.pin.top().left().right().sizeToFit(.content)
    if postkind == .공모전 {
      jobCategoryView.pin.top(to: navigationBar.edge.bottom).left().right().sizeToFit()
      postListSkeleton.pin.top(to: jobCategoryView.edge.bottom).left().right().bottom()
      scrollView.pin.left().right().bottom().top(to: jobCategoryView.edge.bottom)
    } else {
      postListSkeleton.pin.top(to: navigationBar.edge.bottom).left().right().bottom()
      scrollView.pin.left().right().bottom().top(to: navigationBar.edge.bottom)
    }
    contentView.pin.top().left().right()
    contentView.flex.layout(mode: .adjustHeight)
    scrollView.contentSize = contentView.frame.size
    collectionView.flex.markDirty()
  }
}
