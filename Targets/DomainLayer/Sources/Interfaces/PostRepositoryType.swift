//
//  PostRepositoryType.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol PostRepositoryType {
  
  // MARK: Methods
  func upload(_ post: Post) -> Single<(isSuccess: Bool, message: String?)>
  func fetchPostList(categoryId: Int, pageable: Pageable) -> Single<[PostCellData]>
  func fetchBanner() -> Single<[BannerCellData]>
}
