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

protocol MyPageCoordinatorType: CoordinatorType {
  func pushWebView(urlString: String)
  func pushTermsPolicyPage()
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
  }

  func pushWebView(urlString: String) {
    let webViewController: WebViewController = .init(urlString: urlString)
    webViewController.modalPresentationStyle = .fullScreen
    navigationController.present(webViewController, animated: true)
  }
  
  func pushTermsPolicyPage() {
    guard let termsPolicyCoordinator = DIContainer.shared.resolve(type: TermsPolicyCoordinatorType.self)
            as? TermsPolicyCoordinator else {
      return
    }
    
    termsPolicyCoordinator.parentCoordinator = self
    addChild(termsPolicyCoordinator)
    termsPolicyCoordinator.start()
  }
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
