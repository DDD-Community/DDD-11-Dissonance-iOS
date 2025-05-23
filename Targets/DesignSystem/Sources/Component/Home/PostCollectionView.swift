//
//  PostCollectionView.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import PinLayout
import FlexLayout
import RxSwift
import RxCocoa
import RxDataSources

public final class PostCollectionView: UIView {
  
  // MARK: - Properties
  private enum Metric {
    static let cellWidth: CGFloat = 148
    static let cellHeight: CGFloat = 236
    static let headerHeight: CGFloat = 92
    static let sectionTopMargin: CGFloat = 24
    static let sectionBottomMargin: CGFloat = 32
    static let horizontalMargin: CGFloat = 20
    static let interGroupSpacing: CGFloat = 16
    static let zero: CGFloat = 0
  }
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
  
  public var cellTapObservable: Observable<IndexPath> {
    collectionView.rx.itemSelected.asObservable()
  }
  
  public let headerTapRelay: PublishRelay<IndexPath> = .init()
  
  private let sectionsRelay: BehaviorRelay<[PostSection]> = .init(value: Array(
    repeating: .init(original: .stub(), items: Array(repeating: .stub(), count: 3)), 
    count: 3
  ))
  
  private var isLoading = true
  private let disposeBag = DisposeBag()
  private var headerDisposeBag = DisposeBag()
  
  private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PostSection>(
    configureCell: { [weak self] (dataSource, collectionView, indexPath, item) in
      guard let self else { return UICollectionViewCell() }
      
      if isLoading {
        let cell: PostSkeletonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
      } else {
        let cell: PostCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setData(item)
        return cell
      }
    },
    configureSupplementaryView: { [weak self] (dataSource, collectionView, kind, indexPath) in
      guard let self else { return UICollectionReusableView() }
      
      if isLoading {
        let header: PostSkeletonHeader = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          for: indexPath
        )
        return header
      } else {
        let header: PostHeader = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          for: indexPath
        )
        let sectionModel = dataSource.sectionModels[indexPath.section]
        header.setData(title: sectionModel.kind.sectionTitle, summary: sectionModel.kind.summary)
        header.tapObservable
          .map { indexPath }
          .bind(to: headerTapRelay)
          .disposed(by: headerDisposeBag)
        return header
      }
    }
  )
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupCollectionView()
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    let sectionsCount: CGFloat = CGFloat(sectionsRelay.value.count)
    let height: CGFloat = 390*sectionsCount
    return CGSize(width: Device.width, height: height)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
  // MARK: - Methods
  public func setupData(_ data: [PostSection]) {
    headerDisposeBag = DisposeBag()
    sectionsRelay.accept(data)
    isLoading = false
    collectionView.reloadData()
  }
  
  private func setupCollectionView() {
    collectionView.setCollectionViewLayout(configureCollectionViewLayout(), animated: false)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isScrollEnabled = false
    collectionView.register(PostCell.self)
    collectionView.register(PostSkeletonCell.self)
    collectionView.register(
      PostHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
    )
    collectionView.register(
      PostSkeletonHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
    )
    
    sectionsRelay
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
  }
  
  private func setupViewHierarchy() {
    addSubview(collectionView)
  }
  
  private func setupLayout() {
    collectionView.pin.all(pin.safeArea)
  }
  
  private func configureCollectionViewLayout() -> UICollectionViewLayout {
    let item = configureItemLayout()
    let group = configureGroupLayout(with: item)
    let section = configureSectionLayout(with: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  
  private func configureItemLayout() -> NSCollectionLayoutItem {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .absolute(Metric.cellWidth),
      heightDimension: .absolute(Metric.cellHeight)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: Metric.zero,
      leading: Metric.zero,
      bottom: Metric.zero,
      trailing: Metric.zero
    )
    return item
  }
  
  private func configureGroupLayout(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(Metric.cellWidth),
      heightDimension: .absolute(Metric.cellHeight)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    return group
  }
  
  private func configureSectionLayout(with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = .init(
      top: Metric.sectionTopMargin,
      leading: Metric.horizontalMargin,
      bottom: Metric.sectionBottomMargin,
      trailing: Metric.horizontalMargin
    )
    section.interGroupSpacing = Metric.interGroupSpacing
    
    let sectionHeader = configureSectionHeaderLayout()
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }
  
  private func configureSectionHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .estimated(Device.width),
      heightDimension: .estimated(Metric.headerHeight)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    return sectionHeader
  }
}
