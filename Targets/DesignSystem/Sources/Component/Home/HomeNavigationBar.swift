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
import RxSwift

public final class HomeNavigationBar: UIView {
  
  private enum Metric {
    static let height: CGFloat = 56
    static let horizontalPadding: CGFloat = 20
    static let statusBarHeight = Device.statusBarFrame.height
    static let one: CGFloat = 1
  }
  
  public var myPageButtonTapObservable: Observable<Void> {
    mypageButton.rx.tap.asObservable()
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    let image = DesignSystemAsset.logoMozip.image
    imageView.image = image.withTintColor(MozipColor.primary500, renderingMode: .alwaysOriginal)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let mypageButton: UIButton = {
    let button = UIButton()
    let image = DesignSystemAsset.personEmpty.image.withTintColor(MozipColor.primary500, renderingMode: .alwaysOriginal)
    button.setImage(image, for: .normal)
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
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return .init(width: Device.width, height: Device.statusBarFrame.height + Metric.height)
  }
  
  // MARK: - Methods
  private func setupInitialState() {
    self.backgroundColor = MozipColor.white
    layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: 8, blur: 8, spread: 0)
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
