//
//  CALayer+.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/16.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public extension CALayer {
  func applyShadow(
    color: UIColor,
    alpha: Float,
    x: CGFloat,
    y: CGFloat,
    blur: CGFloat,
    spread: CGFloat
  ) {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / UIScreen.main.scale
    
    if spread == 0 {
      shadowPath = nil
    } else {
      let rect = bounds.insetBy(dx: -spread, dy: -spread)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
