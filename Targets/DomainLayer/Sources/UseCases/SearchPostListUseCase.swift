//
//  SearchPostListUseCase.swift
//  DomainLayer
//
//  Created by 이원빈 on 12/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol SearchPostListUseCaseType {
  var postRepository: PostRepositoryType { get }
  
  func execute(keyword: String, pageable: Pageable) -> Observable<PostPage>
}

extension SearchPostListUseCaseType {
  func execute(keyword: String, pageable: Pageable) -> Observable<PostPage> {
    postRepository.searchPostList(keyword: keyword, pageable: pageable)
      .asObservable()
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
  }
}

final class SearchPostListUseCase: SearchPostListUseCaseType {
  let postRepository: PostRepositoryType
  
  init(postRepository: PostRepositoryType) {
    self.postRepository = postRepository
  }
}
