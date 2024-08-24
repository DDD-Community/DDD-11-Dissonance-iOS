//
//  PostDetailCoordinator.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

protocol PostDetailCoordinatorType: CoordinatorType {
  func pushWebView()
}

final class PostDetailCoordinator: PostDetailCoordinatorType {
  
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
//    let vc = postDetailViewController()
//    navigationController.setViewControllers([vc], animated: false)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  //TODO: 웹 뷰 디자인 문의 후 구현
  func pushWebView() {}
}

// MARK: - Private
private extension PostDetailCoordinator {
  func postDetailViewController() -> PostDetailViewController {
    //TODO: 추후 구현
    let reactor: PostDetailReactor = .init()
    let viewController: PostDetailViewController = .init(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
