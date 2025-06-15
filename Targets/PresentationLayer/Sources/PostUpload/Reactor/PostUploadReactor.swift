//
//  PostUploadReactor.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer
import Foundation

import ReactorKit

final class PostUploadReactor: Reactor {

  // MARK: - Properties
  private let postUploadUseCase: PostUploadUseCaseType
  private(set) var post: Post
  public let originID: Int? 
  var initialState: State = .init()

  enum Action {
    case updatePost(Post)
    case didTapCompletionButton
  }

  enum Mutation {
    case setPost(Post)
    case setLoading(Bool)
    case setUploadResult(MozipNetworkResult)
  }

  struct State {
    var isEnableComplete: Bool = false
    var isLoading: Bool = false
    var uploadResult: MozipNetworkResult? = nil
  }
  
  // MARK: - Initializer
  init(postUploadUseCase: PostUploadUseCaseType, originID: Int? = nil, originPost: Post? = nil) {
    self.postUploadUseCase = postUploadUseCase
    self.originID = originID
    self.post = originPost ?? .init()
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updatePost(let newPost):   return .just(.setPost(newPost))
    case .didTapCompletionButton:                
      return .concat([
        .just(.setLoading(true)), 
        originID == nil ? uploadPost() : editPost(), 
        .just(.setLoading(false))
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setPost(let newPost):
      post = newPost
      newState.isEnableComplete = post.hasContents
    case .setLoading(let isLoading):   newState.isLoading = isLoading
    case .setUploadResult(let result): newState.uploadResult = result
    }

    return newState
  }
}

// MARK: - Private Extenion
private extension PostUploadReactor {
  func uploadPost() -> Observable<Mutation> {
    postUploadUseCase.upload(with: post)
      .flatMap { Observable<Mutation>.just(.setUploadResult($0)) }
  }
  
  func editPost() -> Observable<Mutation> {
    guard let originID else { return .empty() }
    
    return postUploadUseCase.edit(id: originID, with: post)
      .flatMap { Observable<Mutation>.just(.setUploadResult($0)) }
  }
}
