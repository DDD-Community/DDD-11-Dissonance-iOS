//
//  PostListCoordinator.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

protocol PostListCoordinatorType: CoordinatorType {
  func start(with postKind: PostKind)
  func pushPostDetail(id: Int)
}

final class PostListCoordinator: PostListCoordinatorType {

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
    // FIXME: ViewController 사이 데이터를 주고받을 경우 고려
  }
  
  func start(with postKind: PostKind) {
    let vc = postListViewController(with: postKind)
    navigationController.pushViewController(vc, animated: true)
  }

  func disappear() {
    if childCoordinators.isEmpty && navigationController.presentedViewController == nil {
      parentCoordinator?.removeChild(self)
    }
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
private extension PostListCoordinator {
  func postListViewController(with postKind: PostKind) -> PostListViewController {
    guard let fetchPostListUseCase = DIContainer.shared.resolve(type: FetchPostListUseCaseType.self) else {
      fatalError()
    }
    let reactor = PostListReactor(fetchPostListUseCase: fetchPostListUseCase)
    let viewController = PostListViewController(reactor: reactor, postKind: postKind)
    viewController.coordinator = self
    return viewController
  }
}
