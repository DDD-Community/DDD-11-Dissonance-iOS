//
//  PostSearchReactor.swift
//  PresentationLayer
//
//  Created by 이원빈 on 12/21/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import MozipCore
import DomainLayer
import Foundation

import ReactorKit

final class PostSearchReactor: Reactor {

  // MARK: - Properties
  private let searchPostListUseCase: SearchPostListUseCaseType
  private let mutableRecommendedPostStream: MutableRecommendedPostStream?
  
  var initialState: State = .init()

  // MARK: - Initializer
  init(
    searchPostListUseCase: SearchPostListUseCaseType,
    mutableRecommendedPostStream: MutableRecommendedPostStream? = nil
  ) {
    self.searchPostListUseCase = searchPostListUseCase
    self.mutableRecommendedPostStream = mutableRecommendedPostStream
  }

  enum Action {
    case searchPosts(keyword: String)
    case tapCell(indexPath: IndexPath)
  }

  enum Mutation {
    case setLoading(Bool)
    case setSelectComplete(Bool)
    case setPosts(data: [PostCellData])
    case setSelectedCell(data: PostCellData?)
  }

  struct State {
    var isLoading: Bool = false
    var isSelectComplete: Bool = false
    var selectedCell: PostCellData?
    
    var posts: [PostCellData] = []
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .searchPosts(keyword):  return searchPosts(from: keyword)
    case let .tapCell(indexPath):    return tapCell(at: indexPath)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(bool):        newState.isLoading = bool
    case let .setSelectComplete(bool): newState.isSelectComplete = bool
    case let .setPosts(data):          newState.posts = data
    case let .setSelectedCell(data):   newState.selectedCell = data
    }
    return newState
  }
  
  private func searchPosts(from keyword: String) -> Observable<Mutation> {
    let searchPostListMutation: Observable<Mutation> = searchPostListUseCase
      .execute(keyword: keyword, pageable: .init(page: 0, size: 30, sort: "latest")) // TODO: 추후 페이징 처리
      .delay(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
      .map { .setPosts(data: $0.posts) }
    
    let sequence: [Observable<Mutation>] = [
      .just(.setLoading(true)),
      searchPostListMutation,
      .just(.setLoading(false))
    ]
    return .concat(sequence)
  }
  
  private func tapCell(at indexPath: IndexPath) -> Observable<Mutation> {
    return fetchCellData(at: indexPath)
      .withUnretained(self)
      .flatMap { owner, cellData -> Observable<Mutation> in
        if let mutableRecommendedPostStream = owner.mutableRecommendedPostStream {
          mutableRecommendedPostStream.updatePostInfo(id: cellData.id, subTitle: cellData.title)
          return .just(.setSelectComplete(true))
        } else {
          return Observable.concat([
            .just(.setSelectedCell(data: cellData)),
            .just(.setSelectedCell(data: nil))
          ])
        }
      }
  }
  
  private func fetchCellData(at indexPath: IndexPath) -> Observable<PostCellData> {
    let posts = self.currentState.posts
    let cell = posts[indexPath.row]
    return Observable.just(cell)
  }
}
