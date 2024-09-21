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
  private let postDetailUseCase: PostDetailUseCaseType
  var initialState: State = .init()
  
  enum Action {
    case fetchPost(id: Int)
    case didTapReportButton
  }
  
  enum Mutation {
    case setPost(Post)
    case setLoading(Bool)
    case setReportState(Bool)
    case setFetchError(Bool)
  }
  
  struct State {
    var post: Post = .init()
    var isLoading: Bool = false
    var isSuccessReport: Bool = false
    var isFetchError: Bool = false
  }
  
  // MARK: - Initializer
  init(postDetailUseCase: PostDetailUseCaseType) {
    self.postDetailUseCase = postDetailUseCase
  }
  
  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    // TODO: 추후 구현
    switch action {
    case .fetchPost(let id): return .concat([.just(.setLoading(true)), fetchPost(id: id), .just(.setLoading(false))])
    case .didTapReportButton: return .concat([.just(.setReportState(true)), .just(.setReportState(false))])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setPost(let post):          newState.post = post
    case .setLoading(let isLoading):  newState.isLoading = isLoading
    case .setReportState(let result): newState.isSuccessReport = result
    case .setFetchError(let isError): newState.isFetchError = isError
    }
    
    return newState
  }
}

// MARK: - Private Extenion
private extension PostDetailReactor {
  func fetchPost(id: Int) -> Observable<Mutation> {
    postDetailUseCase.fetchPost(id: id)
      .flatMap { networkResult -> Observable<Mutation> in
        switch networkResult {
        case .success(let post): return .just(.setPost(post))
        case .error: return .just(.setFetchError(true))
        }
      }
  }
}
