//
//  FetchBookmarkListUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 5/16/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import RxSwift

public protocol FetchBookmarkListUseCaseType {
  
  // MARK: - Properties
  var bookmarkRepository: BookmarkRepositoryType { get }
  
  // MARK: - Methodss
  func fetchBookmarkList(pageable: Pageable) -> Observable<[BookmarkCellData]>
}

final class FetchBookmarkListUseCase: FetchBookmarkListUseCaseType {
  
  // MARK: - Properties
  let bookmarkRepository: BookmarkRepositoryType
  
  // MARK: - Initializer
  init(bookmarkRepository: BookmarkRepositoryType) {
    self.bookmarkRepository = bookmarkRepository
  }
  
  // MARK: - Methods
  func fetchBookmarkList(pageable: Pageable) -> Observable<[BookmarkCellData]> {
    return bookmarkRepository.fetchBookmarkList(pageable: pageable)
      .asObservable()
  }
}
