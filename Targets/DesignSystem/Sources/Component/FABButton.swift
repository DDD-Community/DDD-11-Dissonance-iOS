//
//  FABButton.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/11/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

public final class FABButton: UIView {
  
  private enum Metric {
    static let cornerRadius: CGFloat = 36
    static let plusIconTopMargin: CGFloat = 10
    static let textLabelTopMargin: CGFloat = 4
    static let title: String = "공고등록"
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  
  private let plusIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = DesignSystemAsset.plus.image
    return imageView
  }()
  
  private let textLabel = MozipLabel(style: .body4, color: MozipColor.white, text: Metric.title)
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
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
  public func bindAction(target: Any?, action: Selector?) {
    let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
    self.addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .direction(.column)
      .alignItems(.center)
      .cornerRadius(Metric.cornerRadius)
      .backgroundColor(MozipColor.red)
      .define { flex in
        flex.addItem(plusIcon).marginTop(Metric.plusIconTopMargin)
        flex.addItem(textLabel).marginTop(Metric.textLabelTopMargin)
      }
  }
  
  private func setupLayer() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
}
