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
  func didSuccessUpload()
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
    //TODO: 추후 구현
//    let vc = postUploadViewController()
//    navigationController.setViewControllers([vc], animated: false)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  //TODO: 추후 구현
  func didSuccessUpload() { }
}

// MARK: - Private
private extension PostUploadCoordinator {
  func postUploadViewController() -> PostUploadViewController {
    guard let postUploadUseCase = DIContainer.shared.resolve(type: PostUploadUseCaseType.self) else {
      fatalError()
    }
    
    let reactor = PostUploadReactor(postUploadUseCase: postUploadUseCase)
    let viewController = PostUploadViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
