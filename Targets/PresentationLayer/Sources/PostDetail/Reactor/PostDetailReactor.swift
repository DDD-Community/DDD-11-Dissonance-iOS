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
  private let bookmarkUseCase: BookmarkToggleUseCaseType
  public let postID: Int
  var initialState: State = .init()
  
  enum Action {
    case fetchPost
    case didTapReportButton
    case didTapDeleteButton
    case didTapImageView
    case dismissImageViewController
    case didTapBookmarkButton
    case updatePost(Post)
  }
  
  enum Mutation {
    case setPost(Post)
    case setLoading(Bool)
    case setDeleteState(Bool)
    case setDeletionError(Bool)
    case setIsPresentFullImage(Bool)
    case setFetchError(Bool)
    case setReportState(Bool)
    case setReportError(isError: Bool, message: String)
    case setBookmarkState(Bool)
  }
  
  struct State {
    var post: Post = .init()
    var isLoading: Bool = false
    var isDeleted: Bool = false
    var isPresentFullImage: Bool = false
    var isFetchError: Bool = false
    var isDeletionError: Bool = false
    var isSuccessReport: Bool = false
    var isErrorReport: (isError: Bool, message: String) = (false, "")
  }
  
  // MARK: - Initializer
  init(postID: Int, postDetailUseCase: PostDetailUseCaseType, bookmarkUseCase: BookmarkToggleUseCaseType) {
    self.postID = postID
    self.postDetailUseCase = postDetailUseCase
    self.bookmarkUseCase = bookmarkUseCase
  }
  
  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchPost: return .concat([.just(.setLoading(true)), fetchPost(id: postID), .just(.setLoading(false))])
    case .didTapDeleteButton: return .concat([.just(.setLoading(true)), deletePost(id: postID), .just(.setLoading(false))])
    case .didTapReportButton: return .concat([.just(.setLoading(true)), reportPost(id: postID), .just(.setLoading(false))])
    case .didTapImageView: return .just(.setIsPresentFullImage(true))
    case .dismissImageViewController: return .just(.setIsPresentFullImage(false))
    case .didTapBookmarkButton: return toggleBookmark()
    case .updatePost(let post): return .just(.setPost(post))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.isErrorReport = (isError: false, message: "")
    
    switch mutation {
    case .setPost(let post):          newState.post = post
    case .setLoading(let isLoading):  newState.isLoading = isLoading
    case .setDeleteState(let isDeleted): newState.isDeleted = isDeleted
    case .setIsPresentFullImage(let isPresent): newState.isPresentFullImage = isPresent
    case .setDeletionError(let isDeletionError): newState.isDeletionError = isDeletionError
    case .setFetchError(let isError): newState.isFetchError = isError
    case .setReportState(let isSuccess): newState.isSuccessReport = isSuccess
    case let .setReportError(isError, message): newState.isErrorReport = (isError: isError, message: message)
    case .setBookmarkState(let isBookmarked): newState.post.isBookmarked = isBookmarked
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
  
  func deletePost(id: Int) -> Observable<Mutation> {
    postDetailUseCase.deletePost(id: id)
      .flatMap { networkResult -> Observable<Mutation> in
        switch networkResult {
        case .success: return .just(.setDeleteState(true))
        case .error: return .just(.setDeletionError(true))
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
  
  func toggleBookmark() -> Observable<Mutation> {
    bookmarkUseCase.toggle(postId: postID)
      .flatMap { isBookmarked -> Observable<Mutation> in 
        return .just(.setBookmarkState(isBookmarked))
      }
  }
}
