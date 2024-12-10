//
//  OrderDropDownMenu.swift
//  DesignSystem
//
//  Created by 이원빈 on 12/8/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import RxCocoa
import RxSwift

public final class OrderDropDownMenu: UIView {
  // MARK: - Properties
  public let isLatestOrder: PublishRelay<Bool> = .init()
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let rootFlexContainer = UIView()

  private let latestLabel = MozipLabel(style: .heading3, color: MozipColor.gray700, text: "최신순")
  private let oldestLabel = MozipLabel(style: .heading3, color: MozipColor.gray700, text: "마감순")
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupViewLayout()
    setupInitialState()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupViewLayout()
  }
  
  // MARK: - Methods
  private func bind() {
    latestLabel.isUserInteractionEnabled = true
    oldestLabel.isUserInteractionEnabled = true
    
    latestLabel.rxGesture.tap
      .map { _ in return true }
      .bind(to: isLatestOrder)
      .disposed(by: disposeBag)
    
    oldestLabel.rxGesture.tap
      .map { _ in return false }
      .bind(to: isLatestOrder)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Layout
  private func setupViewHierarchy() {
    self.addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .direction(.column)
      .justifyContent(.spaceEvenly)
      .alignItems(.center)
      .define { flex in
        flex.addItem(latestLabel)
        flex.addItem(oldestLabel)
      }
  }
  
  private func setupViewLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
    pin.size(.init(width: 90, height: 116))
    layer.applyShadow(
      color: .black,
      alpha: 0.05,
      x: 0,
      y: 0,
      blur: 8,
      spread: 5
    )
  }
  
  private func setupInitialState() {
    self.layer.cornerRadius = 8
    self.backgroundColor = MozipColor.white
  }
}
