//
//  HomeViewController.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/5/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DesignSystem

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class HomeViewController: BaseViewController<HomeReactor>, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: HomeCoordinator?
  
  // MARK: - UI
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let navigationBar = HomeNavigationBar()
  private let bannerView = RecommendingBanner()
  private let collectionView = PostCollectionView()
  private let fabButton = FABButton()
  private let homeSkeleton = HomeSkeleton()
  
  private let recommandingTitleLabel = MozipLabel(
    style: .heading1,
    color: MozipColor.gray800,
    text: "오늘의 추천 공고"
  )
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Initializer
  init(reactor: HomeReactor) {
    super.init()
    
    self.reactor = reactor
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  override func bind(reactor: HomeReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    super.setupViews()
    bind()
    setupInitialState()
  }
  
  override func viewDidLayoutSubviews() {
    setupViewLayout()
  }
  
  // MARK: - Methods
  private func setupViewHierarchy() {
    view.addSubview(navigationBar)
    view.addSubview(homeSkeleton)
    view.addSubview(scrollView)
    view.addSubview(fabButton) // TODO: 관리자 로그인의 경우만 표출
    scrollView.addSubview(contentView)
    
    contentView.flex
      .direction(.column)
      .justifyContent(.start)
      .define { flex in
        flex.addItem(recommandingTitleLabel).marginLeft(20).marginTop(32)
        flex.addItem(bannerView).height(154).marginTop(24).marginLeft(20).marginRight(20)
        flex.addItem(collectionView).marginTop(32).grow(1).markDirty()
      }
  }
  
  private func setupViewLayout() {
    navigationBar.pin.top().left().right().sizeToFit()
    homeSkeleton.pin.top(to: navigationBar.edge.bottom).left().right().bottom()
    scrollView.pin.left().right().bottom().top(to: navigationBar.edge.bottom)
    fabButton.pin.right(21).bottom(51).sizeToFit()  // TODO: 관리자 로그인의 경우만 표출
    contentView.pin.top().left().right()
    contentView.flex.layout(mode: .adjustHeight)
    scrollView.contentSize = contentView.frame.size
    collectionView.flex.markDirty()
  }
  
  private func setupInitialState() {
    scrollView.alpha = 0
    // TODO: 관리자 인지 여부에 따라 FAB 버튼 노출
  }
}

// MARK: - Private Extenion
private extension HomeViewController {
  
  // MARK: Properties
  typealias Action = HomeReactor.Action
  typealias State = HomeReactor.State
  
  // MARK: Methods
  func bindAction(reactor: HomeReactor) {
    rx.viewDidLoad
      .map { Action.fetchPosts }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewDidLoad
      .map { Action.fetchBanners }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    collectionView.cellTapObservable
      .asSignal(onErrorJustReturn: IndexPath())
      .map { Action.tapCell(indexPath: $0) }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: HomeReactor) {
    reactor.state
      .map { $0.isSuccessPostFetch && $0.isSuccessBannerFetch }
      .distinctUntilChanged()
      .filter { $0 }
      .asSignal(onErrorJustReturn: true)
      .emit(with: self, onNext: { owner, _ in
        UIView.animate(withDuration: 0.5) {
          owner.scrollView.alpha = 1
        }
        owner.homeSkeleton.hide()
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.postSections }
      .distinctUntilChanged()
      .filter { !$0.isEmpty }
      .asSignal(onErrorJustReturn: [])
      .emit(with: self) { owner, postSections in
        owner.collectionView.setupData(postSections)
        owner.collectionView.pin.sizeToFit()
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.banners }
      .distinctUntilChanged()
      .filter { !$0.isEmpty }
      .asSignal(onErrorJustReturn: [])
      .emit(with: self) { owner, banners in
        owner.bannerView.setupData(banners)
        owner.bannerView.start()
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
  
  func bind() {
    navigationBar.myPageButtonTapObservable
      .asSignal(onErrorJustReturn: ())
      .emit(with: self) { owner, _ in
        owner.coordinator?.pushMyPage()
      }
      .disposed(by: disposeBag)
    
    bannerView.bannerTapObservable
      .asSignal(onErrorJustReturn: .stub())
      .emit(with: self) { owner, banner in
        owner.coordinator?.pushPostDetail(id: String(banner.featuredPostId))
      }
      .disposed(by: disposeBag)
    
    collectionView.headerTapRelay
      .asSignal()
      .emit(with: self) { owner, indexPath in
        let list = owner.reactor?.currentState.postHeaderTitles ?? []
        let code = list[indexPath.section]
        owner.coordinator?.pushPostList(code: code)
      }
      .disposed(by: disposeBag)
    
    fabButton.rxGesture.tap
      .asSignal(onErrorJustReturn: .init())
      .emit(with: self) { owner, _ in
        owner.coordinator?.pushPostRegister()
      }
      .disposed(by: disposeBag)
  }
}
