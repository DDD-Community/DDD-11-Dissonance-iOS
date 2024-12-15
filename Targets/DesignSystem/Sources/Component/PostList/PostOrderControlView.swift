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
  
  public let isOrderButtonTappedRelay: BehaviorRelay<Bool> = .init(value: false)
  private var disposeBag = DisposeBag()
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  private let totalCountLabel = MozipLabel(style: .body2, color: MozipColor.gray600)
  private let orderButton = OrderButton()
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupInitialSetting()
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
  
  // MARK: - Methods
  public func setCount(_ count: Int) {
    totalCountLabel.updateTextKeepingAttributes("공고 \(count)개")
    totalCountLabel.flex.markDirty()
    setNeedsLayout()
  }
  
  public func setOrder(_ order: PostOrder) {
    orderButton.setTitle(text: order.title)
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
        flex.addItem(orderButton)
      }
  }
  
  private func setupLayer() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
  
  private func setupInitialSetting() {}
  
  private func bind() {
    orderButton.rxGesture.tap
      .bind(with: self) { owner, _ in
        let currentValue = owner.isOrderButtonTappedRelay.value
        owner.isOrderButtonTappedRelay.accept(!currentValue)
      }
      .disposed(by: disposeBag)
  }
}
