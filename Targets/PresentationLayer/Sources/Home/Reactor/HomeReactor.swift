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
//  private let fetchPostUseCase: FetchPostUseCaseType
//  private let fetchBannerUseCase: FetchBanerUseCaseType
  var initialState: State = .init()

  // MARK: - Initializer
  init() {
    // TODO: 추후 UseCase 주입
//    self.fetchPostUseCase = fetchPostUseCase
//    self.fetchBannerUseCase = fetchBannerUseCase
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
      return fakeFetchPostUseCase().map { .setPosts(data: $0) }
    case .fetchBanners:
      return fakeFetchBannerUseCase().map { .setBanners(data: $0) }
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
  
  // MARK: -  TEST 용 MockAPI
  private func fakeFetchPostUseCase() -> Observable<[PostSection]> {
    let data: [PostSection] = [
      .stub(header: "동아리", items: [.stub(id: "마감id" ,remainTag: "마감"), .stub(), .stub(), .stub()]),
      .stub(header: "공모전"),
      .stub(header: "해커톤")
    ]
    return Observable.just(data).delay(.seconds(2), scheduler: MainScheduler.instance)
  }
  
  private func fakeFetchBannerUseCase() -> Observable<[BannerCellData]> {
    let data: [BannerCellData] = [
      .stub(featuredPostId: 0),
      .stub(featuredPostId: 1),
      .stub(featuredPostId: 2),
      .stub(featuredPostId: 3),
      .stub(featuredPostId: 4),
    ]
    return Observable.just(data).delay(.seconds(2), scheduler: MainScheduler.instance)
  }
  
  private func fetchCellData(from indexPath: IndexPath) -> Observable<PostCellData> {
    let postSections = self.currentState.postSections
    let cell = postSections[indexPath.section].items[indexPath.row]
    return Observable.just(cell)
  }
}
