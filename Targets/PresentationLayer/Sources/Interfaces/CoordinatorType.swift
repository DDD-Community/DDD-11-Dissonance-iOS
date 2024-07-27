//
//  CoordinatorType.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public protocol CoordinatorType: AnyObject {

  // MARK: - Properties
  var parentCoordinator: CoordinatorType? { get set }
  var childCoordinators: [CoordinatorType] { get set }
  var navigationController: UINavigationController { get set }

  // MARK: - Methods
  func start()
  func didFinish()
}

// MARK: - Default Implementation
public extension CoordinatorType {
  func addChild(_ child: CoordinatorType) {
    childCoordinators.append(child)
  }

  func removeChild(_ child: CoordinatorType?) {
    for (idx, coordinator) in childCoordinators.enumerated() {
      if coordinator === child {
        childCoordinators.remove(at: idx)
        break
      }
    }
  }
}
