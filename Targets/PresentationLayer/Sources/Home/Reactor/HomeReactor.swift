//
//  HomeReactor.swift
//  PresentationLayer
//
//  Created by 이원빈 on 8/5/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import DomainLayer
import Foundation

import ReactorKit

final class HomeReactor: Reactor {

  // MARK: - Properties
  private let fetchPostListUseCase: FetchPostListUseCaseType
  private let fetchBannerUseCase: FetchBannerUseCaseType
  private let userUseCase: UserUseCaseType
  var initialState: State = .init()

  // MARK: - Initializer
  init(
    fetchPostListUseCase: FetchPostListUseCaseType,
    fetchBannerUseCase: FetchBannerUseCaseType,
    userUseCase: UserUseCaseType
  ) {
    self.fetchPostListUseCase = fetchPostListUseCase
    self.fetchBannerUseCase = fetchBannerUseCase
    self.userUseCase = userUseCase
  }

  enum Action {
    case fetchPosts
    case fetchBanners
    case fetchUserInfo
    case tapCell(indexPath: IndexPath)
  }

  enum Mutation {
    case setPosts(data: [PostSection])
    case setBanners(data: [BannerCellData])
    case setSelectedCell(data: PostCellData?)
    case setUserInfo(isAdmin: Bool, provider:String)
  }

  struct State {
    var isSuccessPostFetch: Bool = false
    var isSuccessBannerFetch: Bool = false
    var postHeaderTitles: [String] = []
    var selectedCell: PostCellData? 
    
    var postSections: [PostSection] = []
    var banners: [BannerCellData] = []
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchPosts:             return fetchPosts()
    case .fetchBanners:           return fetchBanners()
    case .fetchUserInfo:          return fetchUserInfo()
    case .tapCell(let indexPath): return tapCell(at: indexPath)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setPosts(data):
      newState.postSections = data
      newState.postHeaderTitles = data.map { $0.header }
      newState.isSuccessPostFetch = true
    case let .setBanners(data):
      newState.banners = data
      newState.isSuccessBannerFetch = true
    case let .setSelectedCell(data):
      newState.selectedCell = data
    case let .setUserInfo(isAdmin, provider):
      saveUserInfo(isAdmin: isAdmin, provider: provider)
    }
    return newState
  }
  
  private func tapCell(at indexPath: IndexPath) -> Observable<Mutation> {
    let postSections = self.currentState.postSections
    let cell = postSections[indexPath.section].items[indexPath.row]
    
    return Observable.concat([
      .just(.setSelectedCell(data: cell)),
      .just(.setSelectedCell(data: nil))
    ])
  }
  
  private func fetchPosts() -> Observable<Mutation> {
    return Observable.zip(
      fetchPostListUseCase.execute(categoryId: 1, pageable: .defaultValue),
      fetchPostListUseCase.execute(categoryId: 2, pageable: .defaultValue),
      fetchPostListUseCase.execute(categoryId: 3, pageable: .defaultValue)
    )
    .map { (firstGroup, secondGroup, thirdGroup) in
        .setPosts(data: [
          firstGroup.toPostSection(header: "공모전 📑", summary: "커리어 성장을 위한 IT 공모전 모음"),
          secondGroup.toPostSection(header: "해커톤 🏆", summary: "단기간 프로젝트를 경험할 수 있는 해커톤"),
          thirdGroup.toPostSection(header: "IT 동아리 💻", summary: "사이드 프로젝트 경험을 쌓는 IT 동아리")
        ])
    }
    // TODO: .catch { error in ... } 에러처리 필요.
  }
  
  private func fetchBanners() -> Observable<Mutation> {
    return fetchBannerUseCase.execute()
      .do(onError: { error in
        print(error.localizedDescription)
      })
      .map { .setBanners(data: $0) }
      // TODO: .catch { error in ... } 에러처리 필요.
  }
  
  private func fetchUserInfo() -> Observable<Mutation> {
    userUseCase.fetchUserInformation()
      .flatMap { Observable<Mutation>.just(.setUserInfo(isAdmin: $0.isAdmin, provider: $0.provider)) }
  }
  
  private func saveUserInfo(isAdmin: Bool, provider: String) {
    guard let isAdminData = "\(isAdmin)".data(using: .utf8),
          let providerData = provider.data(using: .utf8)
    else { fatalError() }
    
    AuthManager.save(authInfoType: .isAdmin, data: isAdminData)
    AuthManager.save(authInfoType: .provider, data: providerData)
  }
}
