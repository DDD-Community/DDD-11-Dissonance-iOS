//
//  UITextField+.swift
//  DesignSystem
//
//  Created by 이원빈 on 12/21/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public extension UITextField {
  func setLeftPadding(_ amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }
}
