//
//  PostUploadUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public enum PostUploadResult: Error, Equatable {
  case success
  case error(message: String?)
}

public protocol PostUploadUseCaseType {
  
  // MARK: - Properties
  var postRepository: PostRepositoryType { get }
  
  // MARK: - Methods
  func execute(with post: Post) -> Observable<PostUploadResult>
}

final class PostUploadUseCase: PostUploadUseCaseType {
  
  // MARK: - Properties
  let postRepository: PostRepositoryType
  private let disposeBag: DisposeBag = .init()
  
  // MARK: - Initializer
  init(postRepository: PostRepositoryType) {
    self.postRepository = postRepository
  }
  
  // MARK: - Methods
  func execute(with post: Post) -> Observable<PostUploadResult> {
    return postRepository.upload(post)
      .asObservable()
      .map { (isSuccess, message) -> PostUploadResult in
        if isSuccess {
          return .success
        }
        
        return .error(message: message)
      }
  }
}
