//
//  HomeViewController.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/5/24.
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

final class HomeViewController: BaseViewController<HomeReactor>, Coordinatable {
  
  // MARK: Properties
  weak var coordinator: HomeCoordinator?
  
  // MARK: UI
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let navigationBar = HomeNavigationBar()
  private let bannerView = RecommendingBanner()
  private let collectionView = PostCollectionView()
  private let fabButton = FABButton()
  
  private let fabSubButton = FABSubButton(
    iconImage: DesignSystemAsset.registerPost.image,
    title: "공고 등록"
  )
  
  private let fabButtonDimmingView: UIView = {
    let view = UIView()
    view.backgroundColor = MozipColor.dim
    return view
  }()
  private let homeSkeleton = HomeSkeleton()
  
  private let recommandingTitleLabel = MozipLabel(
    style: .heading1,
    color: MozipColor.gray800,
    text: "MD Pick 금주의 공고"
  )
  
  private let recommandingIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DesignSystemAsset.pin.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  // MARK: Initializer
  init(reactor: HomeReactor) {
    super.init()
    
    self.reactor = reactor
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Overrides
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    fabButton.isHidden = !AppProperties.isAdmin
  }
  
  override func bind(reactor: HomeReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    super.setupViews()
    
    bindView()
    setupInitialState()
  }
  
  override func viewDidLayoutSubviews() {
    setupViewLayout()
  }
  
  // MARK: Methods
  func setupInitialState() {
    scrollView.alpha = 0
    scrollView.refreshControl = UIRefreshControl()
    scrollView.refreshControl?.addTarget(
      self,
      action: #selector(pullToRefresh(_:)),
      for: .valueChanged
    )
    fabButtonDimmingView.isHidden = true
  }
  
  @objc private func pullToRefresh(_ sender: UIRefreshControl) {
    reactor?.action.onNext(.fetchPosts)
    reactor?.action.onNext(.fetchBanners)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      sender.endRefreshing()
    }
  }
}

// MARK: - Rx Bind
private extension HomeViewController {
  
  // MARK: Properties
  typealias Action = HomeReactor.Action
  typealias State = HomeReactor.State
  
  // MARK: Methods
  func bindAction(reactor: HomeReactor) {
    rx.viewWillAppear
      .map { Action.fetchPosts }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewWillAppear
      .map { Action.fetchBanners }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewWillAppear
      .map { Action.fetchUserInfo }
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
  
  func bindView() {
    navigationBar.myPageButtonTapObservable
      .asSignal(onErrorJustReturn: ())
      .emit(with: self) { owner, _ in
        GA.logEvent(.마이페이지버튼)
        AppProperties.accessToken == .init() ? owner.coordinator?.pushLoginPage() : owner.coordinator?.pushMyPage()
      }
      .disposed(by: disposeBag)
    
    navigationBar.searchButtonTapObservable
      .asSignal(onErrorJustReturn: ())
      .emit(with: self) { owner, _ in
        GA.logEvent(.검색버튼)
        owner.coordinator?.pushPostSearch()
      }
      .disposed(by: disposeBag)
    
    bannerView.bannerTapObservable
      .asSignal(onErrorJustReturn: .stub())
      .emit(with: self) { owner, banner in
        GA.logEvent(.배너이미지)
        owner.coordinator?.pushPostDetail(id: banner.infoPostID)
      }
      .disposed(by: disposeBag)
    
    collectionView.headerTapRelay
      .asSignal()
      .emit(with: self) { owner, indexPath in
        let postHeaders = owner.reactor?.currentState.postHeaders ?? []
        let postKind = postHeaders[indexPath.section]
        switch postKind {
        case .contest: GA.logEvent(.공모전더보기버튼)
        case .hackathon: GA.logEvent(.해커톤더보기버튼)
        case .club: GA.logEvent(.IT동아리더보기버튼)
        }
        owner.coordinator?.pushPostList(postKind: postKind)
      }
      .disposed(by: disposeBag)
    
    fabSubButton.rxGesture.tap
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self) { owner, _ in
        owner.fabButton.isExpanded.accept(false)
        owner.coordinator?.pushPostRegister()
      }
      .disposed(by: disposeBag)
    
    fabButtonDimmingView.rxGesture.tap
      .asSignal(onErrorSignalWith: .empty())
      .map { _ in false }
      .emit(to: fabButton.isExpanded)
      .disposed(by: disposeBag)
    
    fabButton.isExpanded
      .asDriver()
      .drive(with: self) { owner, bool in
        UIView.animate(withDuration: 0.3) {
          owner.fabButtonDimmingView.isHidden = !bool
          owner.updateFABButtonLayout()
        }
        owner.view.setNeedsLayout()
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Layout
private extension HomeViewController {
  func setupViewHierarchy() {
    view.addSubview(navigationBar)
    view.addSubview(homeSkeleton)
    view.addSubview(scrollView)
    view.addSubview(fabButtonDimmingView)
    view.addSubview(fabSubButton)
    view.addSubview(fabButton)
    scrollView.addSubview(contentView)
    
    contentView.flex
      .direction(.column)
      .justifyContent(.start)
      .define { flex in
        flex.addItem()
          .direction(.row)
          .marginTop(32)
          .define { flex in
            flex.addItem(recommandingTitleLabel).marginLeft(20)
            flex.addItem(recommandingIcon).size(17).marginLeft(8)
          }
        flex.addItem(bannerView).width(Device.width-40).aspectRatio(2).marginTop(24).marginLeft(20).marginRight(20)
        flex.addItem(collectionView).marginTop(32).grow(1).markDirty()
      }
  }
  
  func setupViewLayout() {
    navigationBar.pin.top().left().right().sizeToFit()
    homeSkeleton.pin.top(to: navigationBar.edge.bottom).left().right().bottom()
    scrollView.pin.left().right().bottom().top(to: navigationBar.edge.bottom)
    fabButtonDimmingView.pin.all()
    fabButton.pin.right(21).bottom(51).sizeToFit()
    updateFABButtonLayout()
    contentView.pin.top().left().right()
    contentView.flex.layout(mode: .adjustHeight)
    scrollView.contentSize = contentView.frame.size
    collectionView.flex.markDirty()
  }
  
  private func updateFABButtonLayout() {
    if fabButton.isExpanded.value {
      fabSubButton.pin
        .bottom(to: fabButton.edge.top)
        .right()
        .marginRight(20)
        .marginBottom(24)
      fabSubButton.alpha = 1
    } else {
      fabSubButton.pin
        .bottomRight(to: fabButton.anchor.topRight)
      fabSubButton.alpha = 0
    }
  }
}
