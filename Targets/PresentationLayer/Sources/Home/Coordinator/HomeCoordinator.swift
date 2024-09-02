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

protocol HomeCoordinatorType: CoordinatorType {
  func pushPostList(code: String)
  func pushMyPage()
  func pushPostDetail(id: String)
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
  
  func pushPostDetail(id: String) {
    // TODO: 공고 상세페이지로 이동
    print("TODO: 공고(\(id)) 상세페이지로 이동")
  }
  
  func pushPostRegister() {
    // TODO: 공고 등록화면으로 이동
    print("TODO: 공고 등록 화면으로 이동")
  }
}

// MARK: - Private
private extension HomeCoordinator {
  func homeViewController() -> HomeViewController {
    let reactor = HomeReactor()
    let viewController = HomeViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
