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
  func execute(with post: Post) -> Observable<MozipNetworkResult>
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
  func execute(with post: Post) -> Observable<MozipNetworkResult> {
    return postRepository.upload(post)
      .asObservable()
      .map { (isSuccess, message) -> MozipNetworkResult in
        isSuccess ? .success : .error(message: message)
      }
      .catchAndReturnNetworkError()
  }
}
