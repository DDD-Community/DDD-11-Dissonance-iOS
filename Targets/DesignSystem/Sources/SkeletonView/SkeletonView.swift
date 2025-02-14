//
//  SkeletonView.swift
//  DesignSystem
//
//  Created by 한상진 on 12/16/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout

final class SkeletonView: UIView {
  init() {
    super.init(frame: .zero)
    
    backgroundColor = MozipColor.gray10
    layer.cornerRadius = 8
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
