//
//  RemainDayTag.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

public final class RemainDayTag: UIView {
  public enum Mode {
    case light
    case dark
  }
  
  private enum Metric {
    static let height: CGFloat = 24
    static let cornerRadius: CGFloat = 12
    static let horizontalMargin: CGFloat = 8
    static let verticalMargin: CGFloat = 2
    static let lightBackgroundColor: UIColor = MozipColor.gray10
    static let lightTextColor: UIColor = MozipColor.gray500
    static let darkBackgroundColor: UIColor = MozipColor.gray400
    static let darkTextColor: UIColor = MozipColor.white
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  private let tagLabel = MozipLabel(style: .body4, color: MozipColor.gray500)
  
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
    setupLayout()
  }
  
  // MARK: - Methods
  public func setText(_ text: String, mode: Mode = .light) {
    tagLabel.updateTextKeepingAttributes(text)
    setMode(mode)
  }
  
  private func setMode(_ mode: Mode) {
    let backgroundColor = (mode == .light ? Metric.lightBackgroundColor : Metric.darkBackgroundColor)
    let textColor = (mode == .light ? Metric.lightTextColor : Metric.darkTextColor)
    
    rootFlexContainer.backgroundColor = backgroundColor
    tagLabel.updateColorKeepingAttributed(textColor)
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex.define { flex in
      flex.addItem(tagLabel).marginHorizontal(Metric.horizontalMargin).marginVertical(Metric.verticalMargin)
      flex.view?.layer.cornerRadius = Metric.cornerRadius
    }
  }
  
  private func setupLayout() {
    self.pin.height(Metric.height).width(rootFlexContainer.frame.width) /// 이렇게 처리해도 되는지 의문
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout(mode: .adjustWidth)
  }
}
