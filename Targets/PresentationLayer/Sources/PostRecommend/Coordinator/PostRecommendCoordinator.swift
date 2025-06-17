//
//  PostRecommendCoordinator.swift
//  PresentationLayer
//
//  Created by 이원빈 on 2/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit

protocol PostRecommendCoordinatorType: CoordinatorType {
  func start()
  func pushPostSearch(at index: Int)
}

final class PostRecommendCoordinator: PostRecommendCoordinatorType {

  // MARK: - Properties
  weak var parentCoordinator: CoordinatorType?
  var childCoordinators: [CoordinatorType] = []
  var navigationController: UINavigationController
  var mutableRecommendedPostStream: MutableRecommendedPostStream

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.mutableRecommendedPostStream = MutableRecommendedPostStreamImpl()
  }

  // MARK: - Methods
  func start() {
    let vc = postRecommendViewController()
    navigationController.pushViewController(vc, animated: true)
  }
  
  func pushPostSearch(at index: Int) {
    let coordinator = PostSearchCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    mutableRecommendedPostStream.setTargetIndex(index)
    coordinator.startSelectMode(stream: mutableRecommendedPostStream)
    self.addChild(coordinator)
  }
}

// MARK: - Private
private extension PostRecommendCoordinator {
  func postRecommendViewController() -> PostRecommendViewController {
    guard let fetchBannerUseCase = DIContainer.shared.resolve(type: FetchBannerUseCaseType.self),
          let updateBannerUseCase = DIContainer.shared.resolve(type: UpdateBannerUseCaseType.self) else {
      fatalError()
    }
    let reactor = PostRecommendReactor(
      recommendedPostStream: mutableRecommendedPostStream,
      fetchBannerUseCase: fetchBannerUseCase,
      updateBannerUseCase: updateBannerUseCase
    )
    let viewController = PostRecommendViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
