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
  func start(postID: Int)
  func pushWebView(urlString: String)
  func pushErrorView()
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
  func start() {}
  
  func start(postID: Int) {
    let postDetailViewController = postDetailViewController(postID: postID)
    navigationController.pushViewController(postDetailViewController, animated: true)
  }
  
  func didFinish() {
    parentCoordinator?.removeChild(self)
    navigationController.popViewController(animated: true)
  }

  func pushWebView(urlString: String) {
    let webViewController: WebViewController = .init(urlString: urlString)
    webViewController.modalPresentationStyle = .fullScreen
    navigationController.present(webViewController, animated: true)
  }
  
  //TODO: 에러 뷰 구현 필요
  func pushErrorView() {}
}

// MARK: - Private
private extension PostDetailCoordinator {
  func postDetailViewController(postID: Int) -> PostDetailViewController {
    guard let postDetailUseCase = DIContainer.shared.resolve(type: PostDetailUseCaseType.self) else {
      fatalError()
    }
    
    let reactor = PostDetailReactor(postID: postID, postDetailUseCase: postDetailUseCase)
    let viewController = PostDetailViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
