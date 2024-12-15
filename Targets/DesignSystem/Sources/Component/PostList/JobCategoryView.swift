//
//  JobCategoryView.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/26/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer
import UIKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

public final class JobCategoryView: UIView {
  private enum Metric {
    static let cellSpacing: CGFloat = 8
  }
  
  // MARK: - Properties
  public let selectionRelay: BehaviorRelay<ContestCategory> = .init(value: .all)
  private let dataRelay: BehaviorRelay<[String]> = .init(value: ContestCategory.allCases.map { $0.rawValue })
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  private var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
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
    setupLayer()
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return .init(width: Device.width, height: 64)
  }
  
  // MARK: - Methods
  public func setupData(titles: [String]) {
    dataRelay.accept(titles)
    // TODO: 추후 카테고리 목록를 서버에서 받아올 때 사용
  }
  
  private func setupCollectionView() {
    let flowLayout = configureCollectionViewFlowLayout()
    collectionView.setCollectionViewLayout(flowLayout, animated: false)
    collectionView.delegate = self
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(JobCategoryCell.self)
  }
  
  private func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = Metric.cellSpacing
    flowLayout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    return flowLayout
  }
  
  private func fetchCell(at indexPath: IndexPath) -> JobCategoryCell {
    guard let cell = collectionView.cellForItem(at: indexPath) as? JobCategoryCell else {
      return JobCategoryCell(frame: .zero)
    }
    return cell
  }
  
  private func setupViewHierarchy() {
    addSubview(collectionView)
  }
  
  private func setupLayer() {
    collectionView.pin.all()
    collectionView.flex.layout()
  }
  
  private func bind() {
    dataRelay
      .bind(
        to: collectionView.rx.items(
          cellIdentifier: JobCategoryCell.defaultReuseIdentifier,
          cellType: JobCategoryCell.self)
      ) { [weak self] index, item, cell in
        guard let self = self else { return }
        let image = self.fetchImage(from: item)
        let mode = self.fetchSelectedState(from: item)
        cell.setData(text: item, icon: image, mode: mode)
      }
      .disposed(by: disposeBag)
    
    selectionRelay
      .distinctUntilChanged()
      .delay(.milliseconds(50), scheduler: MainScheduler.instance)
      .bind(with: self) { owner, contestCategory in
        for (i, item) in ContestCategory.allCases.enumerated() {
          let cell = owner.fetchCell(at: .init(row: i, section: 0))
          cell.setMode(contestCategory == item ? .dark : .light)
        }
      }
      .disposed(by: disposeBag)
    
    Observable.combineLatest(collectionView.rx.itemSelected, dataRelay)
      .map { (indexPath, dataList) in ContestCategory.init(rawValue: dataList[indexPath.row]) ?? .all }
      .bind(to: selectionRelay)
      .disposed(by: disposeBag)
  }
  
  private func fetchImage(from item: String) -> UIImage? {
    switch item {
    case "개발":       return DesignSystemAsset.developIcon.image
    case "디자인":      return DesignSystemAsset.designIcon.image
    case "기획·아이디어": return DesignSystemAsset.pmIcon.image
    default:           return nil
    }
  }
  
  private func fetchSelectedState(from item: String) -> JobCategoryCell.Mode {
    selectionRelay.value.rawValue == item ? .dark : .light
  }
}

extension JobCategoryView: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let label = MozipLabel(style: .body2, color: .black)
    let value = dataRelay.value[indexPath.row]
    label.updateTextKeepingAttributes(value)
    label.sizeToFit()
    var cellWidth: CGFloat = .zero
    if value == "전체" {
      cellWidth = label.frame.width + 30 /// "전체" 셀의 너비
    } else {
      cellWidth = label.frame.width + 20 + 24 + 8 /// 아이콘을 포함하는 셀의 너비
    }
    return CGSize(width: cellWidth, height: 40)
  }
}
