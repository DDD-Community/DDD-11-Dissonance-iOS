//
//  Device.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/6/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public struct Device {
  public static var statusBarFrame: CGRect {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let statusBarManager = windowScene.statusBarManager {
      return statusBarManager.statusBarFrame
    } else {
      return CGRect()
    }
  }
  
  public static var width: CGFloat {
    return UIScreen.main.bounds.width
  }
}
