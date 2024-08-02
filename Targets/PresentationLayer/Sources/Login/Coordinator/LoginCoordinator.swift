//
//  LoginCoordinator.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

protocol LoginCoordinatorType: CoordinatorType {
  func didSuccessLogin()
}

final class LoginCoordinator: LoginCoordinatorType {

  // MARK: - Properties
  weak var parentCoordinator: CoordinatorType?
  var childCoordinators: [CoordinatorType] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let vc = loginViewController()
    navigationController.setViewControllers([vc], animated: false)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  func didSuccessLogin() {
    //TODO: 추후 구현
    print("didSuccessLogin()")
  }
}

// MARK: - Private
private extension LoginCoordinator {
  func loginViewController() -> LoginViewController {
    guard let loginUseCase = DIContainer.shared.resolve(type: LoginUseCaseType.self) else {
      fatalError()
    }
    
    let reactor = LoginReactor(loginUseCase: loginUseCase)
    let viewController = LoginViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
