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

public extension Reactive where Base: UIViewController {
  var viewDidLoad: Observable<Void> {
    self.methodInvoked(#selector(Base.viewDidLoad))
      .map { _ in }
  }
  
  var viewWillAppear: Observable<Void> {
    self.methodInvoked(#selector(Base.viewWillAppear(_:)))
      .map { _ in }
  }
  
  var viewDidAppear: Observable<Void> {
    self.methodInvoked(#selector(Base.viewDidAppear(_:)))
      .map { _ in }
  }
  
  var viewWillDisappear: Observable<Void> {
    self.methodInvoked(#selector(Base.viewWillDisappear(_:)))
      .map { _ in }
  }
  
  var viewDidDisappear: Observable<Void> {
    self.methodInvoked(#selector(Base.viewDidDisappear(_:)))
      .map { _ in }
  }
}
