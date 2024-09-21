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
  func start(categoryTitle: String, postID: Int)
  func pushWebView()
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
  
  func start(categoryTitle: String, postID: Int) {
    //TODO: 추후 구현
    let vc = postDetailViewController(categoryTitle: categoryTitle, postID: postID)
    navigationController.setViewControllers([vc], animated: false)
  }
  
  func didFinish() {
    parentCoordinator?.removeChild(self)
    navigationController.popViewController(animated: true)
  }

  //TODO: 웹 뷰 디자인 문의 후 구현
  func pushWebView() {}
  
  //TODO: 에러 뷰 구현 필요
  func pushErrorView() {}
}

// MARK: - Private
private extension PostDetailCoordinator {
  func postDetailViewController(categoryTitle: String, postID: Int) -> PostDetailViewController {
    guard let postDetailUseCase = DIContainer.shared.resolve(type: PostDetailUseCaseType.self) else {
      fatalError()
    }
    
    let reactor = PostDetailReactor(postID: postID, postDetailUseCase: postDetailUseCase)
    let viewController = PostDetailViewController(categoryTitle: categoryTitle, reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
