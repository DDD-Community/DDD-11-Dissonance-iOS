//
//  UIImage+.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public extension UIImage {
  static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
      context.cgContext.setFillColor(color.cgColor)
      context.cgContext.fill(CGRect(origin: .zero, size: size))
    }
  }
}
