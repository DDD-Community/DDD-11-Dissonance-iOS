//
//  PostRecommendReactor.swift
//  PresentationLayer
//
//  Created by 이원빈 on 2/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import MozipCore
import DomainLayer
import Foundation

import ReactorKit
import RxSwift

struct PostRecommendCache {
  @UserDefaultWrapper(key: "cachedRecommendPost", defaultValue: [RecommendCellData]())
  static var cachedRecommendPost: [RecommendCellData]
}

final class PostRecommendReactor: Reactor {
  
  // MARK: - Properties
  var initialState: State = .init()
  private let recommendedPostStream: MutableRecommendedPostStream
  private let fetchBannerUseCase: FetchBannerUseCaseType
  private let updateBannerUseCase: UpdateBannerUseCaseType
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  init(
    recommendedPostStream: MutableRecommendedPostStream,
    fetchBannerUseCase: FetchBannerUseCaseType,
    updateBannerUseCase: UpdateBannerUseCaseType
  ) {
    self.recommendedPostStream = recommendedPostStream
    self.fetchBannerUseCase = fetchBannerUseCase
    self.updateBannerUseCase = updateBannerUseCase
    bindStream()
  }
  
  enum Action {
    case askHistoryIfExist
    case loadData
    case loadCache
    case refreshData([RecommendCellData])
    case imageViewDidTap(Int)
    case inputImage(Data)
    case setUploadableTrue
    case completeButtonDidTap
  }
  
  enum Mutation {
    case setLoading(Bool)
    case setPosts([RecommendCellData])
    case setUploadableTrue
    case setAlertHistoryDataTrue
    case setIsUploadComplete
  }
  
  struct State {
    var isUploadable = false
    var isLoading = false
    var isUploadComplete = false
    var alertHistoryData = false
    var posts: [RecommendCellData] = []
  }
  
  // MARK: - Methods
  func bindStream() {
    recommendedPostStream.data
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .do(onNext: {
        guard $0 != RecommendCellData.initialData else {
          return
        }
        PostRecommendCache.cachedRecommendPost = $0
      })
      .subscribe(with: self) { owner, data in
        owner.action.onNext(.refreshData(data))
        owner.checkUploadable(from: data)
      }
      .disposed(by: disposeBag)
  }
  
  func checkUploadable(from data: [RecommendCellData]) {
    for cellData in data where cellData.isUploadAvailable {
      action.onNext(.setUploadableTrue)
      return
    }
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .askHistoryIfExist:          askHistoryIfExistMutation()
    case .loadData:                   loadDataMutation()
    case .loadCache:                  loadCacheMutation()
    case .setUploadableTrue:          setUplodableMutation()
    case let .refreshData(data):      refreshDataMutation(with: data)
    case let .inputImage(imageData):  inputImageMutation(with: imageData)
    case let .imageViewDidTap(index): imageViewDidTapMutation(at: index)
    case .completeButtonDidTap:       completeButtonDidTapMutation()
    }
  }
  
  func askHistoryIfExistMutation() -> Observable<Mutation> { /// 작성중이던 정보 불러오기
    for post in PostRecommendCache.cachedRecommendPost where post.isChanged {
      return .just(.setAlertHistoryDataTrue)
    }
    return loadDataMutation()
  }
  
  func loadCacheMutation() -> Observable<Mutation> {
    let cacheData = PostRecommendCache.cachedRecommendPost
    recommendedPostStream.updateAllPost(posts: cacheData)
    return .empty()
  }
  
  func loadDataMutation() -> Observable<Mutation> {
    fetchBannerUseCase.execute()
      .map { $0.map { $0.toRecommendCellData() } }
      .withUnretained(self)
      .map { owner, banners in
        owner.recommendedPostStream.updateAllPost(posts: banners)
      }
      .flatMap {
        return Observable<Mutation>.empty()
      }
  }
  
  func setUplodableMutation() -> Observable<Mutation> {
    return .just(.setUploadableTrue)
  }
  
  func refreshDataMutation(with data: [RecommendCellData]) -> Observable<Mutation> {
    .just(.setPosts(data))
  }
  
  func inputImageMutation(with data: Data) -> Observable<Mutation> {
    recommendedPostStream.updatePostImage(data)
    return .empty()
  }
  
  func imageViewDidTapMutation(at index: Int) -> Observable<Mutation> {
    recommendedPostStream.setTargetIndex(index)
    return .empty()
  }
  
  func completeButtonDidTapMutation() -> Observable<Mutation> {
    
    let bannerForUpdate = recommendedPostStream.data.value.filter { $0.isUploadAvailable }
    var streams: [Observable<Mutation>] = []
    for banner in bannerForUpdate {
      guard let imageData = banner.imageData else { continue }
      
      let requestDTO = BannerUpdateRequestDTO.init(
        featuredPostId: banner.featuredPostID,
        infoPostId: banner.infoID,
        imgFile: imageData
      )
      let requestStream = updateBannerUseCase.execute(requestDTO: requestDTO)
        .do(onError: {
          print($0.localizedDescription)
        })
        .flatMap { _ in
          return Observable<Mutation>.empty()
        }
      streams.append(requestStream)
    }
    
    let mergedStream: Observable<Mutation> = .merge(streams)
    
    return .concat([
      .just(.setLoading(true)),
      mergedStream,
      .just(.setLoading(false)),
      .just(.setIsUploadComplete)
    ])
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setPosts(data):        newState.posts = data
    case let .setLoading(bool):      newState.isLoading = bool
    case .setUploadableTrue:         newState.isUploadable = true
    case .setAlertHistoryDataTrue:   newState.alertHistoryData = true
    case .setIsUploadComplete:       newState.isUploadComplete = true ; PostRecommendCache.cachedRecommendPost = []
    }
    return newState
  }
}
