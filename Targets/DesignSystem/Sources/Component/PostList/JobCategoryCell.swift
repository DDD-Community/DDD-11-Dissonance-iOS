//
//  JobCategoryCell.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/26/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

public final class JobCategoryCell: UICollectionViewCell {
  public enum Mode {
    case light
    case dark // selected
  }
  
  private enum Metric {
    static let height: CGFloat = 32
    static let cornerRadius: CGFloat = 16
    static let horizontalMargin: CGFloat = 12
    static let verticalMargin: CGFloat = 5
    static let lightBackgroundColor: UIColor = MozipColor.white
    static let lightTextColor: UIColor = MozipColor.gray800
    static let darkBackgroundColor: UIColor = MozipColor.primary500
    static let darkTextColor: UIColor = MozipColor.gray10
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  public let tagLabel = MozipLabel(style: .body2, color: MozipColor.gray800)
  
  // MARK: - Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewHierarchy()
    setupInitialSetting()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    tagLabel.text = nil
  }
  
  // MARK: - Methods
  public func setText(_ text: String, mode: Mode = .light) {
    tagLabel.updateTextKeepingAttributes(text)
    setMode(mode)
  }
  
  public func setMode(_ mode: Mode) {
    let backgroundColor = (mode == .light ? Metric.lightBackgroundColor : Metric.darkBackgroundColor)
    let textColor = (mode == .light ? Metric.lightTextColor : Metric.darkTextColor)
    
    rootFlexContainer.backgroundColor = backgroundColor
    tagLabel.updateColorKeepingAttributed(textColor)
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .define { flex in
        flex.addItem(tagLabel)
          .marginHorizontal(Metric.horizontalMargin)
          .marginVertical(Metric.verticalMargin)
      }
  }
  
  private func setupLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout(mode: .adjustWidth)
  }
  
  private func setupInitialSetting() {
    contentView.layer.borderWidth = 1
    contentView.layer.cornerRadius = Metric.cornerRadius
    contentView.layer.borderColor = MozipColor.primary500.cgColor
    rootFlexContainer.layer.cornerRadius = Metric.cornerRadius
  }
}
