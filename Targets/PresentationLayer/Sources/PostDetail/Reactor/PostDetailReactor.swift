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
  private let postID: Int
  var initialState: State = .init()
  
  enum Action {
    case fetchPost
    case didTapReportButton
  }
  
  enum Mutation {
    case setPost(Post)
    case setLoading(Bool)
    case setFetchError(Bool)
    case setReportState(Bool)
    case setReportError(isError: Bool, message: String)
  }
  
  struct State {
    var post: Post = .init()
    var isLoading: Bool = false
    var isFetchError: Bool = false
    var isSuccessReport: Bool = false
    var isErrorReport: (isError: Bool, message: String) = (false, "")
  }
  
  // MARK: - Initializer
  init(postID: Int, postDetailUseCase: PostDetailUseCaseType) {
    self.postID = postID
    self.postDetailUseCase = postDetailUseCase
  }
  
  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchPost: return .concat([.just(.setLoading(true)), fetchPost(id: postID), .just(.setLoading(false))])
    case .didTapReportButton: return .concat([.just(.setLoading(true)), reportPost(id: postID), .just(.setLoading(false))])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.isErrorReport = (isError: false, message: "")
    
    switch mutation {
    case .setPost(let post):          newState.post = post
    case .setLoading(let isLoading):  newState.isLoading = isLoading
    case .setFetchError(let isError): newState.isFetchError = isError
    case .setReportState(let isSuccess): newState.isSuccessReport = isSuccess
    case let .setReportError(isError, message): newState.isErrorReport = (isError: isError, message: message)
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
  
  func reportPost(id: Int) -> Observable<Mutation> {
    postDetailUseCase.report(id: id)
      .flatMap { networkResult -> Observable<Mutation> in
        switch networkResult {
        case .success: return .just(.setReportState(true))
        case .error(let message): return .just(.setReportError(isError: true, message: message ?? ""))
        }
      }
  }
}
