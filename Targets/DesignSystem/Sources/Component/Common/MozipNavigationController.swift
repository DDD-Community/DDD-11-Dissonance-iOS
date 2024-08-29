//
//  MozipNavigationController.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/29/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public final class MozipNavigationController: UINavigationController {
  public override var childForStatusBarStyle: UIViewController? {
    return visibleViewController
  }
}
