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
    static let cornerRadius: CGFloat = 20
    static let lightBackgroundColor: UIColor = MozipColor.primary50
    static let lightTextColor: UIColor = MozipColor.primary500
    static let darkBackgroundColor: UIColor = MozipColor.primary500
    static let darkTextColor: UIColor = MozipColor.gray10
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  private let tagLabel = MozipLabel(style: .heading3, color: MozipColor.primary500)
  private let leftIconView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
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
  public func setData(text: String, icon: UIImage?, mode: Mode = .light) {
    if let iconImage = icon {
      leftIconView.image = iconImage
      leftIconView.flex.size(24).marginRight(8)
      rootFlexContainer.flex.layout()
    }
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
      .direction(.row)
      .alignItems(.center)
      .justifyContent(.center)
      .define { flex in
        flex.addItem(leftIconView)
        flex.addItem(tagLabel)
      }
  }
  
  private func setupLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout(mode: .fitContainer)
  }
  
  private func setupInitialSetting() {
    contentView.layer.cornerRadius = Metric.cornerRadius
    rootFlexContainer.layer.cornerRadius = Metric.cornerRadius
  }
}
