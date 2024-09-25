//
//  PostListReactor.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import DomainLayer
import Foundation

import ReactorKit

final class PostListReactor: Reactor {

  // MARK: - Properties
  private let fetchPostListUseCase: FetchPostListUseCaseType
  var initialState: State = .init()

  // MARK: - Initializer
  init(
    fetchPostListUseCase: FetchPostListUseCaseType
  ) {
      self.fetchPostListUseCase = fetchPostListUseCase
  }

  enum Action {
    case fetchPosts(id: Int, order: PostOrder)
    case tapCell(indexPath: IndexPath)
  }

  enum Mutation {
    case setLoading
    case setPosts(data: [PostCellData])
    case setSelectedCell(data: PostCellData)
  }

  struct State {
    var isLoading: Bool = false
    var selectedCell: PostCellData?
    
    var posts: [PostCellData] = []
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .fetchPosts(id, order):
      return .concat([
        .just(.setLoading),
        fetchPostListUseCase.execute(
          categoryId: id,
          pageable: .init(page: 0, size: 30, sort: order.rawValue) // FIXME: 추후 페이징처리
        )
        .map { .setPosts(data: $0) }
      ])
    case let .tapCell(indexPath):
      return fetchCellData(at: indexPath).map { .setSelectedCell(data: $0) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setLoading:
      newState.isLoading = true
      newState.selectedCell = nil
    case let .setPosts(data):
      newState.posts = data
      newState.isLoading = false
    case let .setSelectedCell(data):
      newState.selectedCell = data
    }
    return newState
  }
  
  private func fetchCellData(at indexPath: IndexPath) -> Observable<PostCellData> {
    let posts = self.currentState.posts
    let cell = posts[indexPath.row]
    return Observable.just(cell)
  }
}
