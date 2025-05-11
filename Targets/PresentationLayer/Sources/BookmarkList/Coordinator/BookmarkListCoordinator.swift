//
//  BookmarkListCoordinator.swift
//  PresentationLayer
//
//  Created by 이원빈 on 5/8/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

protocol BookmarkListCoordinatorType: CoordinatorType {
  func start()
  func pushPostDetail(id: Int)
}

final class BookmarkListCoordinator: BookmarkListCoordinatorType {
  
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
    let bookmarkListViewController = bookmarkListViewController()
    navigationController.pushViewController(bookmarkListViewController, animated: true)
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
  
  //TODO: 에러 뷰 구현 필요
  func pushErrorView() {}
}

// MARK: - Private
private extension BookmarkListCoordinator {
  func bookmarkListViewController() -> BookmarkListViewController {
    guard let userUsecase = DIContainer.shared.resolve(type: UserUseCaseType.self) else {
      fatalError()
    }
    
    let reactor = BookmarkListReactor(userUsecase: userUsecase)
    let viewController = BookmarkListViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
