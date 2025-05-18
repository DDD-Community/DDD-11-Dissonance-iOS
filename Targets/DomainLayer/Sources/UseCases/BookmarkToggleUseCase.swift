//
//  BookmarkToggleUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 5/16/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import RxSwift

public protocol BookmarkToggleUseCaseType {
  var bookmarkRepository: BookmarkRepositoryType { get }
  
  func toggle(postId: Int) -> Observable<Bool>
}

struct BookmarkToggleUseCase: BookmarkToggleUseCaseType {
  
  // MARK: - Properties
  let bookmarkRepository: BookmarkRepositoryType
  
  // MARK: - Initializer
  init(bookmarkRepository: BookmarkRepositoryType) {
    self.bookmarkRepository = bookmarkRepository
  }
  
  // MARK: - Methods
  func toggle(postId: Int) -> Observable<Bool> {
    return bookmarkRepository.toggle(id: postId)
      .asObservable()
      .map { $0 }
  }
}
