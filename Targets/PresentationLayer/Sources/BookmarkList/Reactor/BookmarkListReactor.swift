//
//  BookmarkListReactor.swift
//  PresentationLayer
//
//  Created by 이원빈 on 5/8/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import DomainLayer

import ReactorKit
import Foundation

final class BookmarkListReactor: Reactor {
  
  // MARK: - Properties
  var initialState: State = .init()
  private let bookmarkUseCase: FetchBookmarkListUseCaseType
  
  enum Action {
    case fetchBookmarkList
  }
  
  enum Mutation {
    case setBookmarkList([BookmarkCellData])
    case setLoading(Bool)
  }
  
  struct State {
    var isLoading: Bool = false
    var bookmarkList: [BookmarkCellData] = []
  }
  
  // MARK: - Initializer
  init(bookmarkUseCase: FetchBookmarkListUseCaseType) {
    self.bookmarkUseCase = bookmarkUseCase
  }
  
  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchBookmarkList: fetchBookmarkListMutation()
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setLoading(bool):      newState.isLoading = bool
    case let .setBookmarkList(data): newState.bookmarkList = data
    }
    
    return newState
  }
}

// MARK: - Private Extenion
private extension BookmarkListReactor {
  
  // MARK: Mutation
  func fetchBookmarkListMutation() -> Observable<Mutation> {
    let pageableMock = Pageable(page: 0, size: 100, sort: PostOrder.latest.rawValue)
    
    let fetchBookmarkListMutation: Observable<Mutation> = bookmarkUseCase
      .fetchBookmarkList(pageable: pageableMock) // FIXME: 페이징 처리 + sort 고정/변동 여부 결정
      .map {.setBookmarkList($0) }
    
    let sequence: [Observable<Mutation>] = [
      .just(.setLoading(true)),
      fetchBookmarkListMutation,
      .just(.setLoading(false))
    ]
    
    return .concat(sequence)
  }
}
