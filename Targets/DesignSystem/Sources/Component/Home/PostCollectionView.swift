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

public protocol PostCollectionViewListener: AnyObject {
  func postCollectionView(_ collectionView: UICollectionView,
                          didSelectHeaderAtIndexPath indexPath: IndexPath)
  // TODO: 셀 탭 액션도 함께 추가
}

public final class PostCollectionView: UIView {
  
  private enum Metric {
    static let cellWidth: CGFloat = 148
    static let cellHeight: CGFloat = 236
    static let headerHeight: CGFloat = 22
    static let sectionTopMargin: CGFloat = 24
    static let sectionBottomMargin: CGFloat = 32
    static let horizontalMargin: CGFloat = 20
    static let interGroupSpacing: CGFloat = 16
    static let zero: CGFloat = 0
  }
  
  public weak var listener: PostCollectionViewListener?
  private var disposeBag = DisposeBag()
  private var sections = BehaviorRelay<[PostSection]>.init(value: [])
  
  private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PostSection>(
    configureCell: { (dataSource, collectionView, indexPath, item) in
      let cell: PostCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.setData(item)
      return cell
    },
    configureSupplementaryView: { [weak self] (dataSource, collectionView, kind, indexPath) in
      guard let self = self else { return UICollectionReusableView() }
      let header: PostHeader = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        for: indexPath)
      let headerTitle = dataSource.sectionModels[indexPath.section].header
      header.setTitle(headerTitle)
      header.showMoreButton.rx.tap
        .bind {  _ in
          self.listener?.postCollectionView(collectionView, didSelectHeaderAtIndexPath: indexPath)
        }
        .disposed(by: disposeBag)
      return header
    })
  
  // MARK: - UI
  private let collectionView: UICollectionView
  private let flowLayout = UICollectionViewFlowLayout()
  
  // MARK: - Initializers
  public init() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    super.init(frame: .zero)
    setupCollectionView()
    setupViewHierarchy()
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
  public func setupData(_ data: [PostSection]) {
    sections.accept(data)
  }
  
  private func setupCollectionView() {
    collectionView.setCollectionViewLayout(configureCollectionViewLayout(), animated: false)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isScrollEnabled = false
    collectionView.register(PostCell.self)
    collectionView.register(
      PostHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    
    sections
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .bind(with: self) { owner, indexPath in
        // TODO: 셀 탭액션 추가 후 Listener 로 전달
      }
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
      widthDimension: .estimated(Device.width - Metric.horizontalMargin*2),
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
