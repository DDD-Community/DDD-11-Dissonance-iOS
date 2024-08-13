//
//  Reactive+.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/13.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift

public extension Reactive where Base: UIGestureRecognizer {
  var tap: Observable<Base> {
    event.filter { $0.state == .recognized }
  }
}
