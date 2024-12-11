//
//  MozipFont.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/14.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

fileprivate typealias pretendard = DesignSystemFontFamily.Pretendard

public enum MozipFontStyle {
  case extraHeading
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
  
  public var font: UIFont {
    switch self {
    case .extraHeading: return pretendard.bold.font(size: 14)
    case .heading1: return pretendard.semiBold.font(size: 20)
    case .heading2: return pretendard.semiBold.font(size: 18)
    case .heading3: return pretendard.semiBold.font(size: 16)
    case .caption1: return pretendard.medium.font(size: 12)
    case .caption2: return pretendard.regular.font(size: 12)
    case .body1: return pretendard.medium.font(size: 16)
    case .body2: return pretendard.regular.font(size: 16)
    case .body3: return pretendard.regular.font(size: 16)
    case .body4: return pretendard.medium.font(size: 14)
    case .body5: return pretendard.regular.font(size: 14)
    case .body6: return pretendard.regular.font(size: 14)
    }
  }
  
  public var lineHeightMultiplier: CGFloat {
    switch self {
    case .extraHeading: return 1
    case .heading1: return 1
    case .heading2: return 1.4
    case .heading3: return 1.4
    case .caption1: return 1
    case .caption2: return 1
    case .body1: return 1.4
    case .body2: return 1.4
    case .body3: return 1.5
    case .body4: return 1.4
    case .body5: return 1.4
    case .body6: return 1.6
    }
  }
}
