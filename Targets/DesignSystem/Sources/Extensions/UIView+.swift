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
  
  static var toastFlag: Bool = false
  
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
  
  func showToast(message: String, duration: CGFloat = 2.0) {
    guard UIView.toastFlag == false else { return }
    let toast = Toast()
    toast.setMessage(message)
    UIView.toastFlag = true
    toast.showIn(view: self, duration: duration) {
      UIView.toastFlag = false
    }
  }
  
  func showSkeleton() {
    let skeletonView = SkeletonView()
    addSubview(skeletonView)
    
    NSLayoutConstraint.activate([
      skeletonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -2),
      skeletonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2),
      skeletonView.topAnchor.constraint(equalTo: topAnchor, constant: -2),
      skeletonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2)
    ])
  }
  
  func hideSkeleton() {
    for subview in subviews.reversed() where subview is SkeletonView {
      subview.removeFromSuperview()
    }
  }
}
