//
//  HomeCoordinator.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/5/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

public protocol HomeCoordinatorType: CoordinatorType {
  func pushPostList(code: String)
  func pushMyPage()
  func pushPostDetail(id: Int)
  func pushPostRegister()
}

final class HomeCoordinator: HomeCoordinatorType {

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
    let vc = homeViewController()
    navigationController.pushViewController(vc, animated: true)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  func pushPostList(code: String) {
    let coordinator = PostListCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    coordinator.start(with: code)
    self.addChild(coordinator)
  }
  
  func pushMyPage() {
    // TODO: 마이페이지로 이동
    print("TODO: 마이페이지로 이동")
  }
  
  func pushPostDetail(id: Int) {
    // TODO: 공고 상세페이지로 이동
    print("TODO: 공고(\(id)) 상세페이지로 이동")
  }
  
  func pushPostRegister() {
    guard let postUploadCoordinator = DIContainer.shared.resolve(type: PostUploadCoordinatorType.self)
            as? PostUploadCoordinator else {
      return
    }
    
    postUploadCoordinator.parentCoordinator = self
    addChild(postUploadCoordinator)
    postUploadCoordinator.start()
  }
}

// MARK: - Private
private extension HomeCoordinator {
  func homeViewController() -> HomeViewController {
    guard let fetchPostListUseCase = DIContainer.shared.resolve(type: FetchPostListUseCaseType.self),
          let fetchBannerUseCase = DIContainer.shared.resolve(type: FetchBannerUseCaseType.self),
          let userUseCase = DIContainer.shared.resolve(type: UserUseCaseType.self) else {
      fatalError()
    }
    let reactor = HomeReactor(
      fetchPostListUseCase: fetchPostListUseCase,
      fetchBannerUseCase: fetchBannerUseCase,
      userUseCase: userUseCase
    )
    let viewController = HomeViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
