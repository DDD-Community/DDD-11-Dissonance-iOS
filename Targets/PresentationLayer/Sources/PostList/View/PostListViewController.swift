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
  
  enum PostKind: String {
    case 동아리 = "동아리"
    case 공모전 = "공모전"
    case 해커톤 = "해커톤"
  }
  
  // MARK: - Properties
  weak var coordinator: PostListCoordinator?
  private let postkind: BehaviorRelay<PostKind> = .init(value: .공모전)
  
  // MARK: - UI
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
  
  // MARK: - Initializer
  init(reactor: PostListReactor, code: String) {
    super.init()
    self.reactor = reactor
    self.postkind.accept(PostKind.init(rawValue: code) ?? .공모전)
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
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
  
  // MARK: - Methods
  private func setupViewHierarchy() {
    view.addSubview(navigationBar)
    if postkind.value == .공모전 {
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
  
  private func setupViewLayout() {
    navigationBar.pin.top().left().right().sizeToFit(.content)
    if postkind.value == .공모전 {
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
  
  private func setupNavigationBar() {
    navigationBar.backButtonTapObservable
      .bind(with: self) { owner, _ in
        owner.coordinator?.didFinish()
      }
      .disposed(by: disposeBag)
  }
  
  private func setupInitialState() {
    scrollView.alpha = 0
  }
}

// MARK: - Private Extenion
private extension PostListViewController {
  
  // MARK: Properties
  typealias Action = PostListReactor.Action
  typealias State = PostListReactor.State
  
  // MARK: Methods
  func bindAction(reactor: PostListReactor) {
    rx.viewDidLoad
      .map { Action.fetchPosts(id: 0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    collectionView.cellTapObservable
      .asSignal(onErrorJustReturn: IndexPath())
      .map { Action.tapCell(indexPath: $0) }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: PostListReactor) {
    reactor.state
      .map { $0.isSuccessPostFetch }
      .distinctUntilChanged()
      .filter { $0 }
      .asSignal(onErrorJustReturn: true)
      .emit(with: self, onNext: { owner, _ in
        UIView.animate(withDuration: 0.5) {
          owner.scrollView.alpha = 1
        }
        owner.postListSkeleton.hide()
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.posts }
      .distinctUntilChanged()
      .filter { !$0.isEmpty }
      .asSignal(onErrorJustReturn: [])
      .emit(with: self) { owner, posts in
        owner.collectionView.setupData(posts)
        owner.collectionView.pin.sizeToFit()
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
    jobCategoryView.selectionRelay
      .distinctUntilChanged()
      .withUnretained(self)
      .filter { owner, _ in owner.postkind.value == .공모전 }
      .bind { ( _, value) in
        // TODO: 데이터 필터링 로직 수행
        print("\(value.rawValue) 탭")
      }
      .disposed(by: disposeBag)
    
    postOrderControlView.latestButtonTapObservable
      .bind(with: self) { owner, _ in
        // TODO: 최신순 정렬
        print("최신순")
      }
      .disposed(by: disposeBag)
    
    postOrderControlView.deadlineButtonTapObservable
      .bind(with: self) { owner, _ in
        // TODO: 마감순 정렬
        print("마감순")
      }
      .disposed(by: disposeBag)
    
    postkind
      .bind(with: self) { owner, postKind in
        owner.navigationBar.setNavigationTitle(postKind.rawValue)
        owner.jobCategoryView.isHidden = !(postKind == .공모전)
      }
      .disposed(by: disposeBag)
  }
}
