//
//  DividerView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/14.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public final class DividerView: UIView {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = MozipColor.gray100
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
