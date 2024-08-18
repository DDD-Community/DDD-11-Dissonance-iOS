//
//  BannerCollectionView.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/9/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class BannerCollectionView: UICollectionView {
  
  private enum Metric {
    static let delaySecond: Double = 1.0
    static let horizontalMargin: CGFloat = 20
    static let height: CGFloat = 154
    static let cornerRadius: CGFloat = 8
    static let firstSection: Int = 0
    static let minimumLineSpacing: CGFloat = 0
    static let contentFirstIndex: Int = 1
    static let pagingOffset: Int = 1
  }
  
  public var currentIndex: BehaviorRelay<Int> = .init(value: Metric.contentFirstIndex)
  public let count: BehaviorRelay<Int> = .init(value: 0)
  private let slideTimeInterval: Double
  private var timer: Timer?
  private var work: DispatchWorkItem?
  private var disposeBag = DisposeBag()
  
  // MARK: - Initializers
  init(slideTimeInterval: Double = 3.0) {
    self.slideTimeInterval = slideTimeInterval
    super.init(frame: .zero, collectionViewLayout: .init())
    self.setupCollectionViewFlowLayout()
    self.setupInitialSetting()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.setFirstIndex()
  }
  
  // MARK: - Methods
  func startAutoScroll() {
    guard timer == nil else { return }
    timer = Timer.scheduledTimer(
      withTimeInterval: slideTimeInterval,
      repeats: true
    ) { [weak self] timer in
      guard let self = self else { return }
      autoScroll()
    }
  }
  
  /// 직접 스와이프할 때를 구독
  func bind(_ subject: Observable<Int>) {
    subject
      .withUnretained(self)
      .subscribe { owner, index in
        owner.currentIndex.accept(index)
        owner.transformIndex()
      }
      .disposed(by: disposeBag)
  }
}

private extension BannerCollectionView {
  
  func transformIndex() {
    let leftEdgeIndex = 0
    let rightEdgeIndex = count.value - Metric.pagingOffset
    
    if currentIndex.value == leftEdgeIndex {
      let contentLastIndex = self.count.value - Metric.pagingOffset*2
      currentIndex.accept(contentLastIndex)
      scrollToItem(
        at: .init(row: currentIndex.value, section: Metric.firstSection),
        at: .centeredHorizontally,
        animated: false)
      delayAutoScroll(for: Metric.delaySecond)
      return
    }
    
    if currentIndex.value == rightEdgeIndex {
      currentIndex.accept(Metric.contentFirstIndex)
      scrollToItem(
        at: .init(row: currentIndex.value, section: Metric.firstSection),
        at: .centeredHorizontally,
        animated: false)
      delayAutoScroll(for: Metric.delaySecond)
      return
    }
    delayAutoScroll(for: Metric.delaySecond)
  }
  
  func stopAutoScroll() {
    timer?.invalidate()
    timer = nil
  }
  
  func setFirstIndex() {
    scrollToItem(
      at: .init(row: Metric.contentFirstIndex, section: Metric.firstSection),
      at: .centeredHorizontally,
      animated: false)
  }
  
  func delayAutoScroll(for second: Double) {
    self.work?.cancel()
    self.work = DispatchWorkItem { [weak self] in
      self?.startAutoScroll()
    }
    self.stopAutoScroll()
    DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: self.work!)
  }
  
  func autoScroll() {
    currentIndex.accept(currentIndex.value + Metric.pagingOffset)
    self.scrollToItem(
      at: .init(row: currentIndex.value, section: Metric.firstSection),
      at: .centeredHorizontally,
      animated: true)
    
    let rightEdgeIndex = count.value - Metric.pagingOffset
    if currentIndex.value == rightEdgeIndex {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
        guard let self = self else { return }
        self.currentIndex.accept(Metric.contentFirstIndex)
        self.scrollToItem(
          at: .init(row: currentIndex.value, section: Metric.firstSection),
          at: .centeredHorizontally,
          animated: false)
      }
      return
    }
  }
  
  func setupCollectionViewFlowLayout() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = Metric.minimumLineSpacing
    flowLayout.itemSize = .init(
      width: Device.width - Metric.horizontalMargin*2,
      height: Metric.height
    )
    self.setCollectionViewLayout(flowLayout, animated: false)
  }
  
  func setupInitialSetting() {
    self.isPagingEnabled = true
    self.showsHorizontalScrollIndicator = false
    self.layer.cornerRadius = Metric.cornerRadius
    register(BannerCell.self)
  }
}
