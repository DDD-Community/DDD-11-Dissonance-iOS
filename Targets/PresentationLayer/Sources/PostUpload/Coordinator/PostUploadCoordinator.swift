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

import RxSwift

protocol PostUploadCoordinatorType: CoordinatorType {
  func startEdit(originID: Int, originPost: Post)
  func completedEdit(post: Post)
}

final class PostUploadCoordinator: PostUploadCoordinatorType {
  
  // MARK: - Properties
  weak var parentCoordinator: CoordinatorType?
  var childCoordinators: [CoordinatorType] = []
  var navigationController: UINavigationController
  
  private let postEditSubject = PublishSubject<Post>()
  var postEditObservable: Observable<Post> {
    postEditSubject.asObservable()
  }

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  func start() {
    let postUploadViewController = postUploadViewController()
    navigationController.pushViewController(postUploadViewController, animated: true)
  }
  
  func startEdit(originID: Int, originPost: Post) {
    let mappedOriginPost = originPost.mapDateValuesToRequestFormat()
    let postUploadViewController = postUploadViewController(originID: originID, originPost: mappedOriginPost)
    navigationController.pushViewController(postUploadViewController, animated: true)
  }
  
  func completedEdit(post: Post) {
    let mappedPost = post.mapDateValuesToResponseFormat()
    postEditSubject.onNext(mappedPost)
  }
}

// MARK: - Private
private extension PostUploadCoordinator {
  func postUploadViewController(originID: Int? = nil, originPost: Post? = nil) -> PostUploadViewController {
    guard let postUploadUseCase = DIContainer.shared.resolve(type: PostUploadUseCaseType.self) else {
      fatalError()
    }
    
    let reactor = PostUploadReactor(postUploadUseCase: postUploadUseCase, originID: originID, originPost: originPost)
    let viewController = PostUploadViewController(reactor: reactor)
    viewController.coordinator = self
    return viewController
  }
}
