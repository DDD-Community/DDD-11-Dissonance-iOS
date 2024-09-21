//
//  FetchBannerUseCase.swift
//  DomainLayer
//
//  Created by 이원빈 on 9/14/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol FetchBannerUseCaseType {
  var postRepository: PostRepositoryType { get }
  
  func execute() -> Observable<[BannerCellData]>
}

extension FetchBannerUseCaseType {
  func execute() -> Observable<[BannerCellData]> {
    postRepository.fetchBanner()
      .asObservable()
  }
}

final class FetchBannerUseCase: FetchBannerUseCaseType {
  let postRepository: PostRepositoryType
  
  init(postRepository: PostRepositoryType) {
    self.postRepository = postRepository
  }
}
