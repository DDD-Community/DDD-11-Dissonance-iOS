//
//  PostUploadUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol PostUploadUseCaseType {
  
  // MARK: - Properties
  var postRepository: PostRepositoryType { get }
  
  // MARK: - Methods
  func upload(with post: Post) -> Observable<MozipNetworkResult>
  func edit(id: Int, with post: Post) -> Observable<MozipNetworkResult>
}

final class PostUploadUseCase: PostUploadUseCaseType {
  
  // MARK: - Properties
  let postRepository: PostRepositoryType
  
  // MARK: - Initializer
  init(postRepository: PostRepositoryType) {
    self.postRepository = postRepository
  }
  
  // MARK: - Methods
  func upload(with post: Post) -> Observable<MozipNetworkResult> {
    return postRepository.upload(post)
      .asObservable()
      .map { (isSuccess, message) -> MozipNetworkResult in
        isSuccess ? .success : .error(message: message)
      }
      .catchAndReturnNetworkError()
  }
  
  func edit(id: Int, with post: Post) -> Observable<MozipNetworkResult> {
    return postRepository.edit(id: id, post: post)
      .asObservable()
      .map { (isSuccess, message) -> MozipNetworkResult in
        isSuccess ? .success : .error(message: message)
      }
      .catchAndReturnNetworkError() // FIXME: 구체적인 에러 파악 필요
  }
}
