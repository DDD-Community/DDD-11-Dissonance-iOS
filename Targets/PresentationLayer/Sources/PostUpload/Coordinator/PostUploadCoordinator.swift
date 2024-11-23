//
//  PostUploadCoordinator.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

protocol PostUploadCoordinatorType: CoordinatorType {
  func startEdit(originID: Int, originPost: Post)
}

final class PostUploadCoordinator: PostUploadCoordinatorType {
  
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
    let postUploadViewController = postUploadViewController()
    navigationController.pushViewController(postUploadViewController, animated: true)
  }
  
  func startEdit(originID: Int, originPost: Post) {
    let postUploadViewController = postUploadViewController(originID: originID, originPost: originPost)
    navigationController.pushViewController(postUploadViewController, animated: true)
  }

  func didFinish() {
    navigationController.popViewController(animated: true)
    parentCoordinator?.removeChild(self)
  }
}

// MARK: - Private
private extension PostUploadCoordinator {
  func postUploadViewController(originID: Int? = nil, originPost: Post? = nil) -> PostUploadViewController {
    guard let postUploadUseCase = DIContainer.shared.resolve(type: PostUploadUseCaseType.self) else {
      fatalError()
    }
    
    let reactor = PostUploadReactor(postUploadUseCase: postUploadUseCase, originID: originID, originPost: originPost)
    let viewController = PostUploadViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
