//
//  UIView+.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/13.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift

public extension UIView {
  
  // MARK: - Properties
  var rxGesture: Reactive<UIGestureRecognizer> {
    Reactive<UIGestureRecognizer>(tapGesture())
  }
  
  // MARK: - Methods
  func tapGesture() -> UITapGestureRecognizer {
    let tapGestureRecognizer: UITapGestureRecognizer = .init()
    addGestureRecognizer(tapGestureRecognizer)
    
    return tapGestureRecognizer
  }
  
  func firstResponder() -> UIView? {
    guard !isFirstResponder else {
      return self
    }
    
    for subview in subviews {
      if let firstResponder = subview.firstResponder() {
        return firstResponder
      }
    }
    
    return nil
  }
}
