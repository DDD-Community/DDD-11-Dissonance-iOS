//
//  MockCoordinator.swift
//  PresentationLayerTests
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
@testable import PresentationLayer

protocol MockCoordinatorType: CoordinatorType {
  var startCalled: Bool { get }
  var didFinishCalled: Bool { get }
}

final class MockCoordinator: MockCoordinatorType {
  
  // MARK: - Properties
  var parentCoordinator: CoordinatorType?
  var childCoordinators = [CoordinatorType]()
  var navigationController = UINavigationController()
  private(set) var startCalled = false
  private(set) var didFinishCalled = false
  
  func start() {
    startCalled = true
  }
  
  func didFinish() {
    didFinishCalled = true
  }
}
