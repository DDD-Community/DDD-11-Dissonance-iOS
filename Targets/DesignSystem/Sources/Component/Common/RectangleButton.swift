//
//  RectangleButton.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/16.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public final class RectangleButton: UIButton {
  
  // MARK: - Properties
  public var tapObservable: Observable<Void> {
    rx.tap.asObservable()
  }
  
  // MARK: - Initializer
  public init(title: String = "", fontStyle: MozipFontStyle, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat = 8) {
    super.init(frame: .zero)
    
    setTitle(title, for: .normal)
    titleLabel?.font = fontStyle.font
    setTitleColor(titleColor, for: .normal)
    self.backgroundColor = backgroundColor
    layer.cornerRadius = cornerRadius
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  public func updateTitle(_ title: String) {
    self.setTitle(title, for: .normal)
  }
}
