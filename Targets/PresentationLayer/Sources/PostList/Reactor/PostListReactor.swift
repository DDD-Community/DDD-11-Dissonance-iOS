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
  // FIXME: 추후 UseCase 주입
  //  private let fetchPostUseCase: FetchPostUseCaseType
  var initialState: State = .init()

  // MARK: - Initializer
  init() {
  //    self.fetchPostUseCase = fetchPostUseCase
  }

  enum Action {
    case fetchPosts(id: Int)
    case tapCell(indexPath: IndexPath)
  }

  enum Mutation {
    case setPosts(data: [PostCellData])
    case setSelectedCell(data: PostCellData)
  }

  struct State {
    var isSuccessPostFetch: Bool = false
    var selectedCell: PostCellData?
    
    var posts: [PostCellData] = []
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .fetchPosts(id):
      return fakeFetchPostUseCase(with: id).map { .setPosts(data: $0) }
    case let .tapCell(indexPath):
      return fetchCellData(at: indexPath).map { .setSelectedCell(data: $0) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setPosts(data):
      newState.posts = data
      newState.isSuccessPostFetch = true
    case let .setSelectedCell(data):
      newState.selectedCell = data
    }
    return newState
  }
  
  // MARK: -  TEST 용 MockAPI
  private func fakeFetchPostUseCase(with id: Int) -> Observable<[PostCellData]> {
    let data: [PostCellData] = [
      .stub(id: "0", remainTag: "마감"), .stub(id: "1", remainTag: "D-831"), .stub(), .stub(), .stub(), .stub(), .stub(), .stub()
    ]
    return Observable.just(data).delay(.seconds(1), scheduler: MainScheduler.instance)
  }
  
  private func fetchCellData(at indexPath: IndexPath) -> Observable<PostCellData> {
    let posts = self.currentState.posts
    let cell = posts[indexPath.row]
    return Observable.just(cell)
  }
}
