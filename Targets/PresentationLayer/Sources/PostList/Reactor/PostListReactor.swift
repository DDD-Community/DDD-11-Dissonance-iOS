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
    case fetchNextPage(id: Int, order: PostOrder)
    case tapCell(indexPath: IndexPath)
  }

  enum Mutation {
    case setLoading(Bool)
    case setPosts(data: [PostCellData])
    case setPage(Int)
    case setIsLastPage(Bool)
    case setSelectedCell(data: PostCellData?)
  }

  struct State {
    var isLoading: Bool = false
    var selectedCell: PostCellData?
    var page: Int = 1
    var isLastPage = false
    var posts: [PostCellData] = []
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .fetchPosts(id, order):    return fetchPosts(id: id, order: order)
    case let .fetchNextPage(id, order): return fetchNextPage(id: id, order: order)
    case let .tapCell(indexPath):       return tapCell(at: indexPath)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(bool):          newState.isLoading = bool
    case let .setPosts(data):            newState.posts = data
    case let .setSelectedCell(data):     newState.selectedCell = data
    case let .setPage(number):           newState.page = number
    case let .setIsLastPage(isLastPage): newState.isLastPage = isLastPage
    }
    return newState
  }
  
  private func fetchPosts(id: Int, order: PostOrder) -> Observable<Mutation> {
    let pageUpdateMutation = Observable<Mutation>.just(.setPage(0))
    let fetchPostListMutation: Observable<Mutation> = fetchPostListUseCase
      .execute(
        categoryId: id,
        pageable: .init(page: 0, size: 10, sort: order.rawValue)
      )
      .flatMap { res -> Observable<Mutation> in
        return Observable.concat([
          .just(.setPosts(data: res.posts)),
          .just(.setIsLastPage(res.last))
        ])
      }
      // TODO: .catch { error in ... } 에러처리 필요.
    let sequence: [Observable<Mutation>] = [
      .just(.setLoading(true)),
      pageUpdateMutation,
      fetchPostListMutation,
      .just(.setLoading(false))
    ]
    return .concat(sequence)
  }
  
  private func fetchNextPage(id: Int, order: PostOrder) -> Observable<Mutation> {
    guard currentState.isLastPage == false else { return .empty() }
    let nextPage = currentState.page + 1
    let pageUpdateMutation = Observable<Mutation>.just(.setPage(nextPage))
    
    let fetchNextPageMutation: Observable<Mutation> = fetchPostListUseCase
      .execute(
        categoryId: id,
        pageable: .init(page: Int32(nextPage), size: 10, sort: order.rawValue)
      )
      .withUnretained(self)
      .flatMap { owner, res -> Observable<Mutation> in
          return Observable.concat([
            .just(.setPosts(data: owner.currentState.posts + res.posts)),
            .just(.setIsLastPage(res.last))
          ])
      }
      
    let sequence: [Observable<Mutation>] = [
      .just(.setLoading(true)),
      pageUpdateMutation,
      fetchNextPageMutation,
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
