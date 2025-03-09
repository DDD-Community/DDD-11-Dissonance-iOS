//
//  UpdateBannerUseCase.swift
//  DomainLayer
//
//  Created by 이원빈 on 2/17/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import RxSwift

public protocol UpdateBannerUseCaseType {
  var postRepository: PostRepositoryType { get }
  
  func execute(requestDTO: BannerUpdateRequestDTO) -> Observable<BannerCellData>
}

extension UpdateBannerUseCaseType {
  func execute(requestDTO: BannerUpdateRequestDTO) -> Observable<BannerCellData> {
    postRepository.updateBanner(requestDTO: requestDTO)
      .asObservable()
  }
}

final class UpdateBannerUseCase: UpdateBannerUseCaseType {
  let postRepository: PostRepositoryType
  
  init(postRepository: PostRepositoryType) {
    self.postRepository = postRepository
  }
}
