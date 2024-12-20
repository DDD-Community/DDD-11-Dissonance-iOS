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
    case inputImage(Data)
    case inputTitle(String)
    case inputCategory(String)
    case inputOrganization(String)
    case inputRecruitStartDate(String)
    case inputRecruitEndDate(String)
    case inputJobGroup([String])
    case inputActivityStartDate(String)
    case inputActivityEndDate(String)
    case inputActivityContents(String)
    case inputPostUrlString(String)
    case didTapCompletionButton
  }

  enum Mutation {
    case setImage(Data)
    case setTitle(String)
    case setCategory(String)
    case setOrganization(String)
    case setRecruitStartDate(String)
    case setRecruitEndDate(String)
    case setJobGroup([String])
    case setActivityStartDate(String)
    case setActivityEndDate(String)
    case setActivityContents(String)
    case setPostUrlString(String)
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
    case .inputImage(let imageData):             return .just(.setImage(imageData))
    case .inputTitle(let title):                 return .just(.setTitle(title))
    case .inputCategory(let category):           return .just(.setCategory(category))
    case .inputOrganization(let organization):   return .just(.setOrganization(organization))
    case .inputRecruitStartDate(let startDate):  return .just(.setRecruitStartDate(startDate))
    case .inputRecruitEndDate(let endDate):      return .just(.setRecruitEndDate(endDate))
    case .inputJobGroup(let jobGroups):          return .just(.setJobGroup(jobGroups))
    case .inputActivityStartDate(let startDate): return .just(.setActivityStartDate(startDate))
    case .inputActivityEndDate(let endDate):     return .just(.setActivityEndDate(endDate))
    case .inputActivityContents(let contents):   return .just(.setActivityContents(contents))
    case .inputPostUrlString(let urlString):     return .just(.setPostUrlString(urlString))
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
    case .setImage(let imageData):             post.imageData = imageData
    case .setTitle(let title):                 post.title = title
    case .setCategory(let category):           post.categoryTitle = category
    case .setOrganization(let organization):   post.organization = organization
    case .setRecruitStartDate(let startDate):  post.recruitStartDate = startDate
    case .setRecruitEndDate(let endDate):      post.recruitEndDate = endDate
    case .setJobGroup(let jobGroups):          post.jobGroups = setupJobGroup(jobGroups)
    case .setActivityStartDate(let startDate): post.activityStartDate = startDate
    case .setActivityEndDate(let endDate):     post.activityEndDate = endDate
    case .setActivityContents(let contents):   post.activityContents = contents
    case .setPostUrlString(let urlString):     post.postUrlString = urlString
    case .setLoading(let isLoading):           newState.isLoading = isLoading
    case .setUploadResult(let result):         newState.uploadResult = result
    }

    newState.isEnableComplete = checkPostCompletion(post)
    return newState
  }
}

// MARK: - Private Extenion
private extension PostUploadReactor {
  func checkPostCompletion(_ post: Post) -> Bool {
    if post.imageData.isEmpty {
      return false
    }
    
    for jobGroup in post.jobGroups where jobGroup.isEmpty {
      return false
    }
    
    let isEnable = ![
      post.title, post.categoryTitle, post.organization, post.recruitEndDate, post.activityContents, post.postUrlString
    ].contains(.init())
    
    return isEnable
  }
  
  func setupJobGroup(_ jobGroups: [String]) -> [String] {
    var jobInformationArray: [String] = []
    
    jobGroups.forEach {
      jobInformationArray.append($0)
    }
    
    return jobInformationArray
  }
  
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
