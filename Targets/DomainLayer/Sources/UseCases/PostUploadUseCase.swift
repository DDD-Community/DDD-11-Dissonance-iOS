//
//  PostUploadUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol PostUploadUseCaseType {
  var postUploadRepository: PostUploadRepositoryType { get }
  
  //TODO: API 문서 전달받은 후 수정 예정
  func execute(with post: Post) -> Observable<Bool>
}

final class PostUploadUseCase: PostUploadUseCaseType {
  
  // MARK: - Properties
  let postUploadRepository: PostUploadRepositoryType
  
  // MARK: - Initializer
  init(postUploadRepository: PostUploadRepositoryType) {
    self.postUploadRepository = postUploadRepository
  }
  
  // MARK: - Methods
  //TODO: API 문서 전달받은 후 수정 예정
  func execute(with post: Post) -> Observable<Bool> {
    return .just(true)
  }
}
