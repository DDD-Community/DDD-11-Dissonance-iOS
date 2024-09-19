//
//  PostDetailReactor.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

import ReactorKit

final class PostDetailReactor: Reactor {
  
  // MARK: - Properties
  // TODO: 추후 구현
  //  private let useCase: useCaseType
  var initialState: State = .init()
  
  enum Action {
    case fetchData
    case didTapReportButton
  }
  
  enum Mutation {
    case setPost(Post)
    case setReportState(Bool)
  }
  
  struct State {
    var post: Post = .init()
    var isSuccessReport: Bool = false
  }
  
  // MARK: - Initializer
  // TODO: 추후 구현
  init() { }
  
  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    // TODO: 추후 구현
    switch action {
    case .fetchData: return .empty()
//    case .fetchData:          return .just(.setPost(.stub()))
    case .didTapReportButton: return .concat([.just(.setReportState(true)), .just(.setReportState(false))])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setPost(let post):
      newState.post = post
    case .setReportState(let result):
      newState.isSuccessReport = result
    }
    
    return newState
  }
}
