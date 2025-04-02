//
//  PostSearchCoordinator.swift
//  PresentationLayer
//
//  Created by 이원빈 on 12/21/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

public protocol PostSearchCoordinatorType: CoordinatorType {
  func start()
  func pushPostDetail(id: Int)
}

final class PostSearchCoordinator: PostSearchCoordinatorType {

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
    let vc = postSearchViewController()
    navigationController.pushViewController(vc, animated: true)
  }
  
  func didFinish() {
    navigationController.popViewController(animated: true)
  }
  
  func pushPostDetail(id: Int) {
    guard let postDetailCoordinator = DIContainer.shared.resolve(type: PostDetailCoordinatorType.self)
            as? PostDetailCoordinator else {
      return
    }
    
    postDetailCoordinator.parentCoordinator = self
    addChild(postDetailCoordinator)
    postDetailCoordinator.start(postID: id)
  }
}

// MARK: - Private
private extension PostSearchCoordinator {
  func postSearchViewController() -> PostSearchViewController {
    guard let searchPostListUseCase = DIContainer.shared.resolve(type: SearchPostListUseCaseType.self) else {
      fatalError()
    }
    let reactor = PostSearchReactor(searchPostListUseCase: searchPostListUseCase)
    let viewController = PostSearchViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
