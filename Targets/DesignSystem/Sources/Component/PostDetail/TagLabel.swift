//
//  TagLabel.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout

public final class TagLabel: UILabel {
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Extenion
private extension TagLabel {
  func setupView() {
    clipsToBounds = true
    numberOfLines = 0
    backgroundColor = MozipColor.gray50
    font = MozipFontStyle.extraHeading.font
    textColor = MozipColor.gray600
    textAlignment = .center
    
    flex.paddingHorizontal(12).paddingVertical(8).cornerRadius(18)
  }
}
