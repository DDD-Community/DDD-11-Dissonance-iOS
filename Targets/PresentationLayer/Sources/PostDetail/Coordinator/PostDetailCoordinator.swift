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
  func start(postID: Int)
  func pushWebView(urlString: String)
  func pushErrorView()
  func pushLoginPage()
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
  
  func start(postID: Int) {
    let postDetailViewController = postDetailViewController(postID: postID)
    navigationController.pushViewController(postDetailViewController, animated: true)
  }
  
  func pushEditView(id: Int, post: Post) {
    guard let postUploadCoordinator = DIContainer.shared.resolve(type: PostUploadCoordinatorType.self)
            as? PostUploadCoordinator else {
      return
    }
    
    postUploadCoordinator.parentCoordinator = self
    addChild(postUploadCoordinator)
    postUploadCoordinator.startEdit(originID: id, originPost: post)
  }

  func pushWebView(urlString: String) {
    let webViewController: WebViewController = .init(urlString: urlString)
    webViewController.modalPresentationStyle = .fullScreen
    navigationController.present(webViewController, animated: true)
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
  
  //TODO: 에러 뷰 구현 필요
  func pushErrorView() {}
}

// MARK: - Private
private extension PostDetailCoordinator {
  func postDetailViewController(postID: Int) -> PostDetailViewController {
    guard let postDetailUseCase = DIContainer.shared.resolve(type: PostDetailUseCaseType.self),
          let bookmarkToggleUseCase = DIContainer.shared.resolve(type: BookmarkToggleUseCaseType.self)
    else { fatalError() }
    
    let reactor = PostDetailReactor(postID: postID, postDetailUseCase: postDetailUseCase, bookmarkUseCase: bookmarkToggleUseCase)
    let viewController = PostDetailViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
