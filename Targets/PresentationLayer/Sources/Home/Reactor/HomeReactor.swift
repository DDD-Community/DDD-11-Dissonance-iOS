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
  // TODO: 추후 UseCase 주입
  private let fetchPostListUseCase: FetchPostListUseCaseType
  private let fetchBannerUseCase: FetchBannerUseCaseType
  var initialState: State = .init()

  // MARK: - Initializer
  init(
    fetchPostListUseCase: FetchPostListUseCaseType,
    fetchBannerUseCase: FetchBannerUseCaseType
  ) {
    self.fetchPostListUseCase = fetchPostListUseCase
    self.fetchBannerUseCase = fetchBannerUseCase
  }

  enum Action {
    case fetchPosts
    case fetchBanners
    case tapCell(indexPath: IndexPath)
  }

  enum Mutation {
    case setPosts(data: [PostSection])
    case setBanners(data: [BannerCellData])
    case setSelectedCell(data: PostCellData)
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
    case .fetchPosts:
      return Observable.zip(
        fetchPostListUseCase.execute(categoryId: 1, pageable: .defaultValue),
        fetchPostListUseCase.execute(categoryId: 2, pageable: .defaultValue),
        fetchPostListUseCase.execute(categoryId: 3, pageable: .defaultValue)
      )
      .do(onError: { error in
        print(error.localizedDescription)
        // FIXME: 에러 종류 확인 후 필요하면 VC 까지 넘겨주도록 구현
      })
      .map { (firstGroup, secondGroup, thirdGroup) in
          .setPosts(data: [
            firstGroup.toPostSection(header: "공모전"),
            secondGroup.toPostSection(header: "해커톤"),
            thirdGroup.toPostSection(header: "동아리")
          ])
      }
    case .fetchBanners:
      return fetchBannerUseCase.execute()
        .do(onError: { error in
          print(error.localizedDescription)
          // FIXME: 에러 종류 확인 후 필요하면 VC 까지 넘겨주도록 구현
        })
        .map { .setBanners(data: $0) }
    case .tapCell(let indexPath):
      return fetchCellData(from: indexPath).map { .setSelectedCell(data: $0) }
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
    }
    return newState
  }
  
  private func fetchCellData(from indexPath: IndexPath) -> Observable<PostCellData> {
    let postSections = self.currentState.postSections
    let cell = postSections[indexPath.section].items[indexPath.row]
    return Observable.just(cell)
  }
}
