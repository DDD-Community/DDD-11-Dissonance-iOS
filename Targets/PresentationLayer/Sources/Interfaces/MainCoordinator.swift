//
//  MainCoordinator.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import DIContainer
import UIKit

public protocol MainCoordinatorType: CoordinatorType {
  func startSplash()
}

public final class MainCoordinator: MainCoordinatorType {

  // MARK: - Properties
  public var parentCoordinator: CoordinatorType?
  public var childCoordinators: [CoordinatorType] = []
  public var navigationController: UINavigationController
  private let container: DIContainer = .shared

  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    navigationController.view.backgroundColor = .systemBackground
    self.navigationController = navigationController
  }

  // MARK: - Methods
  public func startSplash() {
    //TODO: 추후 구현
  }

  public func start() {
    //TODO: 추후 수정
    startSignIn()
  }

  public func didFinish() {}
}

// MARK: - Private Extenion
private extension MainCoordinator {
  func startSignIn() {
    guard let loginCoordinator = container.resolve(type: LoginCoordinatorType.self) else {
      return
    }
    
    loginCoordinator.parentCoordinator = self
    addChild(loginCoordinator)
    
    loginCoordinator.start()
  }
}
