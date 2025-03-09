//
//  PostRecommendCollectionView.swift
//  DesignSystem
//
//  Created by 이원빈 on 2/10/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import PinLayout
import FlexLayout
import RxSwift
import RxCocoa

public final class PostRecommendCollectionView: UIView {
  
  private enum Metric {
    static let cellWidth: CGFloat = Device.width - 40
    static let cellHeight: CGFloat = 58 + cellWidth*(1/2)
    static let horizontalMargin: CGFloat = 20
    static let minimumLineSpacing: CGFloat = 50
    static let zero: CGFloat = 0
  }
  // MARK: - Properties
  public let editButtonTapRelay: PublishRelay<Int> = .init()
  public let thumbnailImageTapRelay: PublishRelay<Int> = .init()
  private let dataRelay = BehaviorRelay<[RecommendCellData]>.init(value: [])
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  public let collectionView: UICollectionView = UICollectionView(
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
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
  // MARK: - Methods
  public func setupData(_ data: [RecommendCellData]) {
    self.dataRelay.accept(data)
  }
  
  private func setupCollectionView() {
    let flowLayout = configureCollectionViewLayout()
    collectionView.setCollectionViewLayout(flowLayout, animated: false)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.isScrollEnabled = true
    collectionView.register(RecommendCell.self)
  }
  
  private func configureCollectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = .init(width: Metric.cellWidth, height: Metric.cellHeight)
    layout.sectionInset = .init(
      top: 40,
      left: Metric.horizontalMargin,
      bottom: 40,
      right: Metric.horizontalMargin
    )
    layout.minimumLineSpacing = Metric.minimumLineSpacing
    return layout
  }
  
  private func setupViewHierarchy() {
    addSubview(collectionView)
  }
  
  private func setupLayout() {
    collectionView.pin.all()
  }
  
  private func bind() {
    dataRelay
      .bind(
        to: collectionView.rx.items(
          cellIdentifier: RecommendCell.defaultReuseIdentifier,
          cellType: RecommendCell.self)
      ) { [weak self] index, item, cell in
        guard let self = self else { return }
        cell.setData(item)
        
        cell.editButtonTapObservable.subscribe(onNext: { _ in
          self.editButtonTapRelay.accept(index)
        })
        .disposed(by: cell.disposeBag)
        
        cell.thumbnailImageTapObservable.subscribe(onNext: { _ in
          self.thumbnailImageTapRelay.accept(index)
        })
        .disposed(by: cell.disposeBag)
      }
      .disposed(by: disposeBag)
  }
}
