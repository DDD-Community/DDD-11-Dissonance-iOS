//
//  RecommendingBanner.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/5/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import RxSwift
import RxCocoa

public final class RecommendingBanner: UIView {
  
  private enum Metric {
    static let width: CGFloat = Device.width - 40
  }
  
  public var bannerTapObservable: Observable<BannerCellData> {
    bannerCollectionView.rx.itemSelected
      .withUnretained(self)
      .map { owner, indexPath in owner.dataSource[indexPath.row] }
      .asObservable()
  }
  
  private var dataSource: [BannerCellData] = []
  private var isLoading = true
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  private var bannerCollectionView = BannerCollectionView()
  private let pageControl = UIPageControl()
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayer()
  }
  
  // MARK: - Methods
  public func setupData(_ data: [BannerCellData]) {
    let transformedData = transformData(from: data)
    dataSource = transformedData
    
    if !data.isEmpty {
      setupPageControl()
      bannerCollectionView.dataCount = dataSource.count
    }
    isLoading = false
    bannerCollectionView.reloadData()
  }
  
  public func start() {
    bannerCollectionView.setFirstIndex()
    bannerCollectionView.startAutoScroll()
  }
  
  /// [1,2,3,4] -> [4,1,2,3,4,1]
  private func transformData(from data: [BannerCellData]) -> [BannerCellData] {
      var tmp = data
      guard let last = tmp.last, let first = tmp.first else { return [] }
      tmp.append(first)
      tmp = tmp.reversed()
      tmp.append(last)
      tmp = tmp.reversed()
      return tmp
  }
  
  private func setupCollectionView() {
    bannerCollectionView.dataSource = self
    bannerCollectionView.delegate = self
    
    bannerCollectionView.rx.didEndDecelerating
      .withUnretained(self)
      .map { owner, _ in Int((owner.bannerCollectionView.contentOffset.x / (Metric.width))) }
      .bind(to: bannerCollectionView.directSwipeRelay)
      .disposed(by: disposeBag)
    
    bannerCollectionView.currentIndexRelay
      .map { $0 - 1 }
      .bind(to: pageControl.rx.currentPage)
      .disposed(by: disposeBag)
  }
  
  private func setupPageControl() {
    pageControl.currentPage = 0
    pageControl.numberOfPages = dataSource.count - 2
  }
  
  private func setupViewHierarchy() {
    addSubview(bannerCollectionView)
    addSubview(pageControl)
  }
  
  private func setupLayer() {
    bannerCollectionView.pin.all(pin.safeArea)
    pageControl.pin.bottomCenter(20)
  }
}

// MARK: - CollectionView
extension RecommendingBanner: UICollectionViewDelegate {}

extension RecommendingBanner: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return isLoading ? 1 : dataSource.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView, 
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    if isLoading {
      let cell: BannerSkeletonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      return cell
    } else {
      let cell: BannerCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.setData(dataSource[indexPath.row])
      return cell
    }
  }
}
