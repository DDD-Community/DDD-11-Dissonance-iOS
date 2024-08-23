//
//  RecommendingBanner.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/5/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

public final class RecommendingBanner: UIView {
  
  private enum Metric {
    static let width: CGFloat = Device.width - 40
  }
  
  private let dataRelay = BehaviorRelay<[UIImage]>.init(value: [])
  private let swipeRelay: PublishRelay<Int> = .init()
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
  public func setupData(_ data: [UIImage]) {
    let transformedData = transformData(from: data)
    self.dataRelay.accept(transformedData)
  }
  /// [1,2,3,4] -> [4,1,2,3,4,1]
  private func transformData(from data: [UIImage]) -> [UIImage] {
      var tmp = data
      guard let last = tmp.last, let first = tmp.first else { return [] }
      tmp.append(first)
      tmp = tmp.reversed()
      tmp.append(last)
      tmp = tmp.reversed()
      return tmp
  }
  
  private func setupCollectionView() {

    dataRelay
      .bind(
        to: bannerCollectionView.rx.items(
          cellIdentifier: BannerCell.defaultReuseIdentifier,
          cellType: BannerCell.self)
      ) { index, item, cell in
        cell.setImage(item)
      }
      .disposed(by: disposeBag)
    
    dataRelay
      .skip(1)
      .filter { !$0.isEmpty }
      .bind(with: self) { owner, value in
        owner.setupPageControl()
        owner.bannerCollectionView.dataCount = value.count
      }
      .disposed(by: disposeBag)
    
    bannerCollectionView.rx.didEndDecelerating
      .withUnretained(self)
      .map { owner, _ in Int((owner.bannerCollectionView.contentOffset.x / (Metric.width))) }
      .bind(to: swipeRelay)
      .disposed(by: disposeBag)
    
    bannerCollectionView.rx.itemSelected
      .bind(with: self) { owner, indexPath in
        print("didSelectItemAt \(indexPath.row)")
      }
      .disposed(by: disposeBag)
    
    bannerCollectionView.currentIndexRelay
      .map { $0 - 1 }
      .bind(to: pageControl.rx.currentPage)
      .disposed(by: disposeBag)
    
    bannerCollectionView.startAutoScroll()
    bannerCollectionView.bind(swipeRelay.asObservable())
  }
  
  private func setupPageControl() {
    pageControl.currentPage = 0
    pageControl.numberOfPages = dataRelay.value.count - 2
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
