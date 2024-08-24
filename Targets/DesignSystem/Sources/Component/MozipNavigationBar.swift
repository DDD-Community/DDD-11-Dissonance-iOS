//
//  MozipNavigationBar.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/3/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxSwift

public final class MozipNavigationBar: UIView {
  
  private enum Metric {
    static let backButtonImageResource = "arrow.left"
    static let height: CGFloat = 56
    static let horizontalPadding: CGFloat = 20
    static let buttonSize: CGFloat = 24
    static let rightButtonSpacing: CGFloat = 12
    static let statusBarHeight = Device.statusBarFrame.height
  }
  
  public var backButtonTapObservable: Observable<Void> {
    backButton.rx.tap.asObservable()
  }
  
  // MARK: - UI
  private let backButton: UIButton = {
    let button = UIButton()
    let image = UIImage(systemName: Metric.backButtonImageResource)
    button.setImage(image, for: .normal)
    button.tintColor = .black
    return button
  }()
  
  private let titleLabel = MozipLabel(style: .heading2, color: MozipColor.gray900)
  private let rightButtonFlexContainer = UIView()
  
  // MARK: - Initializers
  public init(title: String, backgroundColor: UIColor) {
    super.init(frame: .zero)
    setupInitialState(title: title, backgroundColor: backgroundColor)
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
  public func setRightButtons(_ buttons: [UIButton]) {
    rightButtonFlexContainer.flex
      .direction(.row)
      .justifyContent(.end)
      .paddingRight(Metric.horizontalPadding)
      .gap(Metric.rightButtonSpacing)
      .define { flex in
        buttons.forEach {
          flex.addItem($0).size(Metric.buttonSize).alignSelf(.center)
        }
      }
  }
  
  private func setupInitialState(title: String, backgroundColor: UIColor) {
    titleLabel.updateTextKeepingAttributes(title)
    self.backgroundColor = backgroundColor
  }
  
  private func setupViewHierarchy() {
    addSubview(backButton)
    addSubview(titleLabel)
    addSubview(rightButtonFlexContainer)
  }
  
  private func setupLayout() {
    backButton.pin.left().margin(Metric.horizontalPadding).vCenter(Metric.statusBarHeight/2).size(Metric.buttonSize)
    titleLabel.pin.hCenter().vCenter(Metric.statusBarHeight/2).sizeToFit(.widthFlexible)
    rightButtonFlexContainer.pin.top(Metric.statusBarHeight).bottom().left(to: titleLabel.edge.right).right()
    rightButtonFlexContainer.flex.layout()
  }
}
