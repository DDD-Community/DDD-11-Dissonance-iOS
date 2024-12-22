//
//  PostListCollectionView.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import PinLayout
import FlexLayout
import RxSwift
import RxCocoa

public final class PostListCollectionView: UIView {
  
  private enum Metric {
    static let cellWidth: CGFloat = (Device.width - 64) / 2
    static let cellHeight: CGFloat = Metric.cellWidth + 16 + 72
    static let horizontalMargin: CGFloat = 20
    static let minimumLineSpacing: CGFloat = 24
    static let zero: CGFloat = 0
  }
  
  public var cellTapObservable: Observable<IndexPath> {
    collectionView.rx.itemSelected.asObservable()
  }
  
  private let dataRelay = BehaviorRelay<[PostSection.Item]>.init(value: [])
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupCollectionView()
    setupViewHierarchy()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    let cellSpacing: CGFloat = Metric.minimumLineSpacing
    let count = dataRelay.value.count
    let offset = CGFloat(count % 2)
    let rowCount: CGFloat = (CGFloat(dataRelay.value.count) / 2) + offset
    
    return CGSize(
      width: Device.width,
      height: Metric.cellHeight*rowCount + cellSpacing*(rowCount-1)
    )
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
  // MARK: - Methods
  public func setupData(_ data: [PostSection.Item]) {
    self.dataRelay.accept(data)
  }
  
  public func setScrollEnable(_ bool: Bool) {
    collectionView.isScrollEnabled = bool
  }
  
  private func setupCollectionView() {
    let flowLayout = configureCollectionViewLayout()
    collectionView.setCollectionViewLayout(flowLayout, animated: false)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.isScrollEnabled = false
    collectionView.register(PostCell.self)
  }
  
  private func configureCollectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = .init(width: Metric.cellWidth, height: Metric.cellHeight)
    layout.sectionInset = .init(
      top: Metric.zero,
      left: Metric.horizontalMargin,
      bottom: Metric.zero,
      right: Metric.horizontalMargin
    )
    layout.minimumLineSpacing = Metric.minimumLineSpacing
    return layout
  }
  
  private func setupViewHierarchy() {
    addSubview(collectionView)
  }
  
  private func setupLayout() {
    collectionView.pin.all(pin.safeArea)
  }
  
  private func bind() {
    dataRelay
      .bind(
        to: collectionView.rx.items(
          cellIdentifier: PostCell.defaultReuseIdentifier,
          cellType: PostCell.self)
      ) { index, item, cell in
        cell.setData(item)
      }
      .disposed(by: disposeBag)
  }
}
