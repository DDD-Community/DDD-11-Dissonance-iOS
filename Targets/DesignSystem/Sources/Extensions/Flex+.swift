//
//  Flex+.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/18.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout

public extension Flex {
  
  @discardableResult
  func addDivider(height: CGFloat = 1, color: UIColor = MozipColor.gray100) -> Flex {
    return addItem().height(height).backgroundColor(color)
  }
}
