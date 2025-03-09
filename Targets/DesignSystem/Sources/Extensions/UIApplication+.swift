//
//  UIApplication+.swift
//  DesignSystem
//
//  Created by 이원빈 on 2/18/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit

public extension UIApplication {
  @available(iOS 15, *)
  static var firstKeyWindowForConnectedScenes: UIWindow? {
    UIApplication.shared
      .connectedScenes.lazy
      .compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }
      .first(where: { $0.keyWindow != nil })?
      .keyWindow
  }
  
  static var topWindow: UIWindow {
    let window: UIWindow
    if #available(iOS 15, *) {
      guard let osWindow = UIApplication.firstKeyWindowForConnectedScenes else { return .init() }
      window = osWindow
    } else {
      guard let osWindow = UIApplication.shared.windows.last else { return .init() }
      window = osWindow
    }
    return window
  }
}
