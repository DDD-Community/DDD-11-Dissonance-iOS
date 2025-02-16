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
  func pushPostList(postKind: PostKind)
  func pushLoginPage()
  func pushMyPage()
  func pushPostDetail(id: Int)
  func pushPostRegister()
  func pushPostRecommend()
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

  func didFinish() {}

  func pushPostList(postKind: PostKind) {
    let coordinator = PostListCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    coordinator.start(with: postKind)
    self.addChild(coordinator)
  }
  
  func pushPostSearch() {
    let coordinator = PostSearchCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    coordinator.start()
    self.addChild(coordinator)
  }
  
  func pushLoginPage() {
    guard let loginCoordinator = DIContainer.shared.resolve(type: LoginCoordinatorType.self)
            as? LoginCoordinator else {
      return
    }
    
    loginCoordinator.parentCoordinator = self
    addChild(loginCoordinator)
    loginCoordinator.start()
  }
  
  func pushMyPage() {
    guard let myPageCoordinator = DIContainer.shared.resolve(type: MyPageCoordinatorType.self)
            as? MyPageCoordinator else {
      return
    }
    
    myPageCoordinator.parentCoordinator = self
    addChild(myPageCoordinator)
    myPageCoordinator.start()
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
  
  func pushPostRegister() {
    guard let postUploadCoordinator = DIContainer.shared.resolve(type: PostUploadCoordinatorType.self)
            as? PostUploadCoordinator else {
      return
    }
    
    postUploadCoordinator.parentCoordinator = self
    addChild(postUploadCoordinator)
    postUploadCoordinator.start()
  }
  
  func pushPostRecommend() {
    // TODO: PostRecommend 화면 생성 후 이동
    guard let postRecommendCoordinator = DIContainer.shared.resolve(type: PostRecommendCoordinatorType.self)
            as? PostRecommendCoordinator else {
      return
    }
    
    postRecommendCoordinator.parentCoordinator = self
    addChild(postRecommendCoordinator)
    postRecommendCoordinator.start()
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
