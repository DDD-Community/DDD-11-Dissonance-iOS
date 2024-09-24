//
//  TermsPolicyCoordinator.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/09/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

protocol TermsPolicyCoordinatorType: CoordinatorType {
  func pushWebView(urlString: String)
}

final class TermsPolicyCoordinator: TermsPolicyCoordinatorType {
  
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
    let termsPolicyViewController = termsPolicyViewController()
    navigationController.pushViewController(termsPolicyViewController, animated: true)
  }
  
  func didFinish() {
    navigationController.popViewController(animated: true)
    parentCoordinator?.removeChild(self)
  }
  
  func pushWebView(urlString: String) {
    let webViewController: WebViewController = .init(urlString: urlString)
    webViewController.modalPresentationStyle = .fullScreen
    navigationController.present(webViewController, animated: true)
  }
}

// MARK: - Private
private extension TermsPolicyCoordinator {
  func termsPolicyViewController() -> TermsPolicyViewController {
    let viewController: TermsPolicyViewController = .init()
    viewController.coordinator = self
    return viewController
  }
}
