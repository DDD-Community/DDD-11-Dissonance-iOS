//
//  BottomShadowView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/16.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public final class BottomShadowView: UIView {
  
  public init() {
    super.init(frame: .zero)
    
    backgroundColor = .white
    layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: -4, blur: 8, spread: 0)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
