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
    case setLoading(Bool)
    case setPosts(data: [PostCellData])
    case setSelectedCell(data: PostCellData?)
  }

  struct State {
    var isLoading: Bool = false
    var selectedCell: PostCellData?
    
    var posts: [PostCellData] = []
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .fetchPosts(id, order): return fetchPosts(id: id, order: order)
    case let .tapCell(indexPath):    return tapCell(at: indexPath)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(bool):      newState.isLoading = bool
    case let .setPosts(data):        newState.posts = data
    case let .setSelectedCell(data): newState.selectedCell = data
    }
    return newState
  }
  
  private func fetchPosts(id: Int, order: PostOrder) -> Observable<Mutation> {
    let fetchPostListMutation: Observable<Mutation> = fetchPostListUseCase
      .execute(
        categoryId: id,
        pageable: .init(page: 0, size: 30, sort: order.rawValue) // FIXME: 추후 페이징처리
      )
      .map { .setPosts(data: $0) }
      // TODO: .catch { error in ... } 에러처리 필요.
    let sequence: [Observable<Mutation>] = [
      .just(.setLoading(true)),
      fetchPostListMutation,
      .just(.setLoading(false))
    ]
    return .concat(sequence)
  }
  
  private func tapCell(at indexPath: IndexPath) -> Observable<Mutation> {
    return fetchCellData(at: indexPath)
      .flatMap { cellData -> Observable<Mutation> in
        Observable.concat([
          .just(.setSelectedCell(data: cellData)),
          .just(.setSelectedCell(data: nil))
        ])
      }
  }
  
  private func fetchCellData(at indexPath: IndexPath) -> Observable<PostCellData> {
    let posts = self.currentState.posts
    let cell = posts[indexPath.row]
    return Observable.just(cell)
  }
}
