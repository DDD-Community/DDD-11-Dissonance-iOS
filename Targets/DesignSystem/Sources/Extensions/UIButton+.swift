//
//  UIButton+.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public extension UIButton {
  func setUnderline() {
    guard let title = title(for: .normal) else {
      return
    }
    
    let attributedString = NSMutableAttributedString(string: title)
    attributedString.addAttribute(
      .underlineStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: NSRange(location: 0, length: title.count)
    )
    setAttributedTitle(attributedString, for: .normal)
  }
}
