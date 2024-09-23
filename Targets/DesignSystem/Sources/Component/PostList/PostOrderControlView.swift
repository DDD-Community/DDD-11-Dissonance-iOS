//
//  PostOrderControlView.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

public final class PostOrderControlView: UIView {
  
  private enum Metric {
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
  }
  
  public var orderRelay: BehaviorRelay<PostOrder> = .init(value: .latest)
  private var disposeBag = DisposeBag()
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  private let totalCountLabel = MozipLabel(style: .body2, color: MozipColor.gray600)
  private let latestButton = SortButton(title: "최신순")
  private let deadlineButton = SortButton(title: "마감순")
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupInitialSetting()
    bindButton()
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
  public func setCount(_ count: Int) {
    totalCountLabel.updateTextKeepingAttributes("공고 \(count)개")
    totalCountLabel.flex.markDirty()
    setNeedsLayout()
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .direction(.row)
      .alignItems(.center)
      .paddingHorizontal(Metric.horizontalPadding)
      .paddingVertical(Metric.verticalPadding)
      .define { flex in
        flex.addItem(totalCountLabel)
        flex.addItem().grow(1)
        flex.addItem(latestButton).width(57).height(32)
        flex.addItem(deadlineButton).width(57).height(32).marginLeft(12)
      }
  }
  
  private func setupLayer() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
  
  private func setupInitialSetting() {
    latestButton.setHighlight(true)
  }
  
  private func bindButton() {
    latestButton.rx.tap
      .map { PostOrder.latest }
      .bind(to: orderRelay)
      .disposed(by: disposeBag)
    
    deadlineButton.rx.tap
      .map { PostOrder.deadline }
      .bind(to: orderRelay)
      .disposed(by: disposeBag)
    
    orderRelay
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: .latest)
      .emit(with: self) { owner, order in
        owner.latestButton.setHighlight(order == .latest)
        owner.deadlineButton.setHighlight(order == .deadline)
      }
      .disposed(by: disposeBag)
  }
}
