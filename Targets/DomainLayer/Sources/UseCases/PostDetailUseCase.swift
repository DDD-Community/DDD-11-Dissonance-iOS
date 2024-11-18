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
  func deletePost(id: Int) -> Observable<MozipNetworkResult>
  func report(id: Int) -> Observable<MozipNetworkResult>
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
  
  func deletePost(id: Int) -> Observable<MozipNetworkResult> {
    return postRepository.delete(id: id)
      .asObservable()
      .map { (isSuccess, message) -> MozipNetworkResult in
        isSuccess ? .success : .error(message: message)
      }
      .catchAndReturnNetworkError()
  }
  
  func report(id: Int) -> Observable<MozipNetworkResult> {
    return postRepository.report(id: id)
      .asObservable()
      .map { (isSuccess, message) -> MozipNetworkResult in
        isSuccess ? .success : .error(message: message)
      }
      .catchAndReturnNetworkError()
  }
}
