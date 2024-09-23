//
//  PostDetailUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/09/21.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public enum PostDetailNetworkResult {
  case success(post: Post)
  case error
}

public protocol PostDetailUseCaseType {
  
  // MARK: - Properties
  var postRepository: PostRepositoryType { get }
  
  // MARK: - Methods
  func fetchPost(id: Int) -> Observable<PostDetailNetworkResult>
}

final class PostDetailUseCase: PostDetailUseCaseType {
  
  // MARK: - Properties
  let postRepository: PostRepositoryType
  
  // MARK: - Initializer
  init(postRepository: PostRepositoryType) {
    self.postRepository = postRepository
  }
  
  // MARK: - Methods
  func fetchPost(id: Int) -> Observable<PostDetailNetworkResult> {
    return postRepository.fetchPost(id: id)
      .asObservable()
      .map { (isSuccess, post) -> PostDetailNetworkResult in
        isSuccess ? .success(post: post) : .error
      }
      .catchAndReturn(.error)
  }
}
