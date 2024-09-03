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
    //TODO: 추후 구현
    let vc = myPageViewController()
    navigationController.setViewControllers([vc], animated: false)
  }
  
  func didFinish() {
    parentCoordinator?.removeChild(self)
    navigationController.popViewController(animated: true)
  }

  //TODO: 웹 뷰 디자인 문의 후 구현
  func pushWebView(_ service: MyPageServices) {}
}

// MARK: - Private
private extension MyPageCoordinator {
  func myPageViewController() -> MyPageViewController {
    //TODO: 추후 구현
    let reactor: MyPageReactor = .init()
    let viewController: MyPageViewController = .init(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
