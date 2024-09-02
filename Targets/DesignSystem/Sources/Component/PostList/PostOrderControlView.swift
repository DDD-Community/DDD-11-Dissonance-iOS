//
//  PostOrderControlView.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift
import PinLayout
import FlexLayout

public final class PostOrderControlView: UIView {
  
  private enum Metric {
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
  }
  
  public var latestButtonTapObservable: Observable<Void> {
    latestButton.tapRelay.filter { $0 }.map { _ in }.asObservable()
  }
  
  public var deadlineButtonTapObservable: Observable<Void> {
    deadlineButton.tapRelay.filter { $0 }.map { _ in }.asObservable()
  }
  
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
      .withLatestFrom(deadlineButton.tapRelay)
      .filter { $0 }
      .bind(with: self) { owner, _ in
        owner.deadlineButton.setHighlight(false)
        owner.latestButton.setHighlight(true)
      }
      .disposed(by: disposeBag)
    
    deadlineButton.rx.tap
      .withLatestFrom(latestButton.tapRelay)
      .filter { $0 }
      .bind(with: self) { owner, _ in
        owner.latestButton.setHighlight(false)
        owner.deadlineButton.setHighlight(true)
      }
      .disposed(by: disposeBag)
  }
}
