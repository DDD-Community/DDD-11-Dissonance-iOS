//
//  MozipLabel.swift
//  DesignSystem
//
//  Created by 이원빈 on 2024/07/26.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public final class MozipLabel: UILabel {
  
  public init(style: MozipLabelStyle, color: UIColor, text: String = "") {
    super.init(frame: .zero)
    self.numberOfLines = 0
    setMozipLabel(style: style, color: color, text: text)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public enum MozipLabelStyle {
  case heading1
  case heading2
  case heading3
  case caption1
  case caption2
  case body1
  case body2
  case body3
  case body4
  case body5
  case body6
  
  var labelSettings: MozipLabelSetting {
    switch self {
    case .heading1:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 20),
        lineHeightMultiplier: 1)
    case .heading2:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 18),
        lineHeightMultiplier: 1.4)
    case .heading3:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
        lineHeightMultiplier: 1.4)
    case .caption1:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
        lineHeightMultiplier: 1)
    case .caption2:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.regular.font(size: 12),
        lineHeightMultiplier: 1)
    case .body1:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
        lineHeightMultiplier: 1.4)
    case .body2:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.regular.font(size: 16),
        lineHeightMultiplier: 1.4)
    case .body3:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.regular.font(size: 16),
        lineHeightMultiplier: 1.5)
    case .body4:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
        lineHeightMultiplier: 1.4)
    case .body5:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.regular.font(size: 14),
        lineHeightMultiplier: 1.4)
    case .body6:
      return MozipLabelSetting(
        font: DesignSystemFontFamily.Pretendard.regular.font(size: 14),
        lineHeightMultiplier: 1.6)
    }
  }
}

public struct MozipLabelSetting {
  let font: UIFont
  let lineHeightMultiplier: CGFloat
}
