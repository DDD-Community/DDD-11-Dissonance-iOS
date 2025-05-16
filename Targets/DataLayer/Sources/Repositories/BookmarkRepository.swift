//
//  BookmarkRepository.swift
//  DataLayer
//
//  Created by 한상진 on 5/16/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import DomainLayer

import Moya
import RxMoya
import RxSwift

public final class BookmarkRepository: BookmarkRepositoryType {
  
  // MARK: - Properties
  private let provider: MoyaProvider<BookmarkAPI>
  
  // MARK: - Initializer
  init(provider: MoyaProvider<BookmarkAPI> = MoyaProvider<BookmarkAPI>()) {
    self.provider = provider
  }
  
  // MARK: - Methods
  public func toggle(id: Int) -> Single<Bool> {
    return provider.rx.request(.toggle(id: id), type: BookmarkToggleResponse.self)
      .map(APIResponse<BookmarkToggleResponse>.self)
      .map { $0.data?.isBookmarked ?? false}
  }
}
