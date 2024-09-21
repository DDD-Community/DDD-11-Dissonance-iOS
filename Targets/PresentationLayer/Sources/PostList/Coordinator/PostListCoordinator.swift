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
  func start(with code: String)
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
  
  func start(with code: String) {
    let vc = postListViewController(with: code)
    navigationController.pushViewController(vc, animated: true)
  }

  func didFinish() {
    navigationController.popViewController(animated: true)
    parentCoordinator?.removeChild(self)
  }
  
  func pushPostDetail(id: Int) {
    // TODO: 공고 상세페이지로 이동
    print("TODO: 공고(\(id)) 상세페이지로 이동")
  }
}

// MARK: - Private
private extension PostListCoordinator {
  func postListViewController(with code: String) -> PostListViewController {
    guard let fetchPostListUseCase = DIContainer.shared.resolve(type: FetchPostListUseCaseType.self) else {
      fatalError()
    }
    let reactor = PostListReactor(fetchPostListUseCase: fetchPostListUseCase)
    let viewController = PostListViewController(reactor: reactor, code: code)
    viewController.coordinator = self
    return viewController
  }
}
