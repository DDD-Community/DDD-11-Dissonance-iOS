//
//  BookmarkRepositoryType.swift
//  DomainLayer
//
//  Created by 한상진 on 5/16/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import RxSwift

public protocol BookmarkRepositoryType {

  // MARK: Methods
  func toggle(id: Int) -> Single<Bool>
  func fetchBookmarkList(pageable: Pageable) -> Single<[BookmarkCellData]>
}
