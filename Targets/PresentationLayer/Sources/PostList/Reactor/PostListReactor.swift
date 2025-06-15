//
//  PostListReactor.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import MozipCore
import DomainLayer
import Foundation

import ReactorKit
import RxCocoa

final class PostListReactor: Reactor {

  // MARK: - Properties
  var initialState: State = .init()
  
  private let fetchPostListUseCase: FetchPostListUseCaseType
  private var page = 1
  private var isLastPage = false

  // MARK: - Initializer
  init(
    fetchPostListUseCase: FetchPostListUseCaseType
  ) {
      self.fetchPostListUseCase = fetchPostListUseCase
  }

  enum Action {
    case fetchPosts(id: Int, order: PostOrder, isFirst: Bool)
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
    case let .fetchPosts(id, order, isFirst): return fetchPostsMutation(id: id, order: order, isFirst: isFirst)
    case let .tapCell(indexPath):             return tapCell(at: indexPath)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(bool):          newState.isLoading = bool
    case let .setPosts(data):            newState.posts = data
    case let .setSelectedCell(data):     newState.selectedCell = data
    }
    return newState
  }
  
  private func fetchPostsMutation(id: Int, order: PostOrder, isFirst: Bool) -> Observable<Mutation> {
    if isFirst { isLastPage = false }
    guard isLastPage == false else { return .empty() }
    page = isFirst ? 0 : page + 1
    
    let fetchPostListMutation: Observable<Mutation> = fetchPostListUseCase
      .execute(
        categoryId: id,
        pageable: .init(page: Int32(page), size: 10, sort: order.rawValue)
      )
      .withUnretained(self)
      .flatMap { owner, res -> Observable<Mutation> in
        owner.isLastPage = res.last
        let data = isFirst ? res.posts : owner.currentState.posts + res.posts
        return Observable.just(.setPosts(data: data))
      }
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
