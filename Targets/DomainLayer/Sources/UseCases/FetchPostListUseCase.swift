//
//  FetchPostListUseCase.swift
//  DomainLayer
//
//  Created by 이원빈 on 9/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol FetchPostListUseCaseType {
  var postRepository: PostRepositoryType { get }
  
  func execute(categoryId: Int, pageable: Pageable) -> Observable<[PostCellData]>
}

extension FetchPostListUseCaseType {
  func execute(categoryId: Int, pageable: Pageable) -> Observable<[PostCellData]> {
    postRepository.fetchPostList(categoryId: categoryId, pageable: pageable)
      .asObservable()
  }
}

final class FetchPostListUseCase: FetchPostListUseCaseType {
  let postRepository: PostRepositoryType
  
  init(postRepository: PostRepositoryType) {
    self.postRepository = postRepository
  }
}
