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
  func pushWebView(urlString: String)
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
    let loginViewController = loginViewController()
    navigationController.pushViewController(loginViewController, animated: true)
  }

  func disappear() {
    if childCoordinators.isEmpty && navigationController.presentedViewController == nil {
      parentCoordinator?.removeChild(self)
    }
  }
  
  func didFinish() {
    navigationController.popViewController(animated: true)
  }
  
  func pushWebView(urlString: String) {
    let webViewController: WebViewController = .init(urlString: urlString)
    webViewController.modalPresentationStyle = .fullScreen
    navigationController.present(webViewController, animated: true)
  }
}

// MARK: - Private
private extension LoginCoordinator {
  func loginViewController() -> LoginViewController {
    guard let loginUseCase = DIContainer.shared.resolve(type: LoginUseCaseType.self),
          let userUseCase = DIContainer.shared.resolve(type: UserUseCaseType.self) else {
      fatalError()
    }
    
    let reactor = LoginReactor(loginUseCase: loginUseCase, userUseCase: userUseCase)
    let viewController = LoginViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
