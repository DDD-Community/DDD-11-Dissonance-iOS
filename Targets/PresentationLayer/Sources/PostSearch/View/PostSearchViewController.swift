//
//  PostSearchViewController.swift
//  PresentationLayer
//
//  Created by 이원빈 on 12/21/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DesignSystem
import DomainLayer

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class PostSearchViewController: BaseViewController<PostSearchReactor>, Alertable, Coordinatable {
  
  // MARK: Properties
  weak var coordinator: PostSearchCoordinator?
  
  private let orderRelay: BehaviorRelay<PostOrder> = .init(value: .latest)
  
  // MARK: UI
  private let collectionView = PostListCollectionView()
  private let searchBar = MozipSearchBar()
  
  private let emptyLabel: MozipLabel = {
    let label = MozipLabel(style: .heading3, color: MozipColor.gray500, text: "검색 결과가 없습니다.")
    label.textAlignment = .center
    return label
  }()
  
  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.style = .medium
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  // MARK: Initializer
  init(reactor: PostSearchReactor) {
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
  override func bind(reactor: PostSearchReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    super.setupViews()
    setupSearchBar()
    setupInitialState()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    setupViewLayout()
  }
  
  // MARK: Methods
  private func setupSearchBar() {
    searchBar.backButtonTapObservable
      .bind(with: self) { owner, _ in
        owner.coordinator?.didFinish()
      }
      .disposed(by: disposeBag)
  }
  
  private func setupInitialState() {
    collectionView.setScrollEnable(true)
  }
}

// MARK: - Private Extenion
private extension PostSearchViewController {
  
  // MARK: Properties
  typealias Action = PostSearchReactor.Action
  typealias State = PostSearchReactor.State
  
  // MARK: Methods
  func bindAction(reactor: PostSearchReactor) {
    collectionView.cellTapObservable
      .asSignal(onErrorJustReturn: IndexPath())
      .map { Action.tapCell(indexPath: $0) }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
    
    collectionView.scrollObervable
      .asSignal(onErrorJustReturn: ())
      .emit(with: self) { owner, _ in
        owner.view.endEditing(true)
      }
      .disposed(by: disposeBag)
    
    searchBar.searchTextObservable
      .filter { $0?.isEmpty == false }
      .distinctUntilChanged()
      .compactMap { $0 }
      .debounce(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
      .map { Action.searchPosts(keyword: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: PostSearchReactor) {
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: false)
      .emit(with: self) { owner, isLoading in
        isLoading ? owner.activityIndicator.startAnimating() : owner.activityIndicator.stopAnimating()
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isSelectComplete)
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: true)
      .emit(with: self) { owner, isComplete in
        if isComplete {
          owner.coordinator?.didFinish()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.posts }
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: [])
      .do(onNext: { [weak self] data in
        self?.emptyLabel.isHidden = !data.isEmpty
      })
      .emit(with: self) { owner, posts in
        owner.collectionView.setupData(posts)
        owner.collectionView.pin.sizeToFit()
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
private extension PostSearchViewController {
  func setupViewHierarchy() {
    view.addSubview(searchBar)
    view.addSubview(collectionView)
    view.addSubview(activityIndicator)
    view.addSubview(emptyLabel)
  }
  
  func setupViewLayout() {
    searchBar.pin.top().left().right().height(Device.statusBarFrame.height + 68)
    activityIndicator.pin.below(of: searchBar).width(100%).bottom()
    emptyLabel.pin.all()
    collectionView.pin.below(of: searchBar).width(100%).bottom()
    collectionView.flex.markDirty()
  }
}
