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
  private var post: Post = .init()
  var initialState: State = .init()

  enum Action {
    case inputImage(Data)
    case inputTitle(String)
    case inputCategory(String)
    case inputOrganization(String)
    case inputRecruitStartDate(String)
    case inputRecruitEndDate(String)
    case inputJobGroup([(String, Int)])
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
    case setJobGroup([(String, Int)])
    case setActivityStartDate(String)
    case setActivityEndDate(String)
    case setActivityContents(String)
    case setPostUrlString(String)
    case uploadPost
    case setLoading(Bool)
  }

  struct State {
    var isEnableComplete: Bool = false
    var isLoading: Bool = false
    var isSuccessUpload = false
  }
  
  // MARK: - Initializer
  init(postUploadUseCase: PostUploadUseCaseType) {
    self.postUploadUseCase = postUploadUseCase
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
    case .didTapCompletionButton:                return .concat([.just(.setLoading(true)), .just(.uploadPost)])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setImage(let imageData):             post.imageData = imageData
    case .setTitle(let title):                 post.title = title
    case .setCategory(let category):           post.category = category
    case .setOrganization(let organization):   post.organization = organization
    case .setRecruitStartDate(let startDate):  post.recruitStartDate = startDate
    case .setRecruitEndDate(let endDate):      post.recruitEndDate = endDate
    case .setJobGroup(let jobGroups):          post.jobGroups = jobGroups
    case .setActivityStartDate(let startDate): post.activityStartDate = startDate
    case .setActivityEndDate(let endDate):     post.activityEndDate = endDate
    case .setActivityContents(let contents):   post.activityContents = contents
    case .setPostUrlString(let urlString):     post.postUrlString = urlString
    case .setLoading(let isLoading):           newState.isLoading = isLoading
    case .uploadPost:                          postUploadUseCase.uploadPost(post) //TODO: API 문서 전달받은 후 수정 예정
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
    
    for jobGroup in post.jobGroups where jobGroup.job.isEmpty {
      return false
    }
    
    let isEnable = ![
      post.title, post.category, post.organization, post.recruitStartDate, post.recruitEndDate,
      post.activityStartDate, post.activityEndDate, post.activityContents, post.postUrlString
    ].contains(.init())
    
    return isEnable
  }
}
