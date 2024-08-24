//
//  HomeNavigationBar.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/11/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

public final class HomeNavigationBar: UIView {
  
  private enum Metric {
    static let height: CGFloat = 56
    static let horizontalPadding: CGFloat = 20
    static let statusBarHeight = Device.statusBarFrame.height
    static let one: CGFloat = 1
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DesignSystemAsset.logoMozip.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  public let mypageButton: UIButton = {
    let button = UIButton()
    button.setImage(DesignSystemAsset.personEmpty.image, for: .normal)
    return button
  }()
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupInitialState()
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
  private func setupInitialState() {
    self.backgroundColor = MozipColor.primary500
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .direction(.row)
      .marginHorizontal(Metric.horizontalPadding)
      .marginTop(Metric.statusBarHeight)
      .define { flex in
        flex.addItem(logoImageView)
        flex.addItem().grow(Metric.one)
        flex.addItem(mypageButton)
      }
  }
  
  private func setupLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
}
