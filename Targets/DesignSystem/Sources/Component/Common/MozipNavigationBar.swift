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
    static let verticalPadding: CGFloat = 16
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
  private let itemsContainer: UIView = .init()
  private let rightButtonFlexContainer = UIView()
  
  // MARK: - Initializers
  public init(title: String, tintColor: UIColor = .black, backgroundColor: UIColor) {
    super.init(frame: .zero)
    setupInitialState(title: title, tintColor: tintColor, backgroundColor: backgroundColor)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    pin.all()
    flex.layout(mode: .adjustHeight)
    titleLabel.pin.all()
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return .init(width: Device.width, height: 56 + Device.statusBarFrame.height)
  }
  
  // MARK: - Methods
  public func setRightButtons(_ buttons: [UIButton]) {
    rightButtonFlexContainer.flex
      .direction(.row)
      .justifyContent(.end)
      .gap(Metric.rightButtonSpacing)
      .marginVertical(Metric.verticalPadding)
      .define { flex in
        buttons.forEach {
          flex.addItem($0).size(Metric.buttonSize)
        }
      }
  }
  
  public func setNavigationTitle(_ title: String) {
    titleLabel.updateTextKeepingAttributes(title)
  }
  
  private func setupInitialState(title: String, tintColor: UIColor, backgroundColor: UIColor) {
    itemsContainer.addSubview(titleLabel)
    titleLabel.updateTextKeepingAttributes(title)
    titleLabel.textAlignment = .center
    titleLabel.updateColorKeepingAttributed(tintColor)
    backButton.tintColor = tintColor
    self.backgroundColor = backgroundColor
  }
  
  private func setupLayout() {
    flex
      .justifyContent(.end)
      .define {
        $0.addItem(itemsContainer)
          .direction(.row)
          .justifyContent(.spaceBetween)
          .marginHorizontal(Metric.horizontalPadding)
          .marginTop(Metric.statusBarHeight)
          .define { itemsContainer in
            itemsContainer.addItem(backButton).size(Metric.buttonSize).marginVertical(Metric.verticalPadding)
            itemsContainer.addItem(rightButtonFlexContainer)
          }
      }
  }
}
