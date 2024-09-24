//
//  MyPageCoordinator.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/30.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

enum MyPageServices {
  case question, policy
}

protocol MyPageCoordinatorType: CoordinatorType {
  func pushWebView(_ service: MyPageServices)
}

final class MyPageCoordinator: MyPageCoordinatorType {
  
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
    let myPageViewController = myPageViewController()
    navigationController.pushViewController(myPageViewController, animated: true)
  }
  
  func didFinish() {
    navigationController.popViewController(animated: true)
    parentCoordinator?.removeChild(self)
  }

  //TODO: 웹 뷰 디자인 문의 후 구현
  func pushWebView(_ service: MyPageServices) {}
}

// MARK: - Private
private extension MyPageCoordinator {
  func myPageViewController() -> MyPageViewController {
    guard let myPageUseCase = DIContainer.shared.resolve(type: MyPageUseCaseType.self) else {
      fatalError()
    }
    
    let reactor: MyPageReactor = .init(useCase: myPageUseCase)
    let viewController: MyPageViewController = .init(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
