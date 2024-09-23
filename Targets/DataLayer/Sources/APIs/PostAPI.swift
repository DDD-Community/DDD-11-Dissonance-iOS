//
//  PostAPI.swift
//  DataLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import DomainLayer
import Foundation

import Moya

enum PostAPI {
  case upload(_ post: Post)
  case fetchPostList(PostListFetchRequestDTO)
  case fetchBanner
  case fetchPost(id: Int)
}

// MARK: - TargetType
extension PostAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }
  
  var path: String {
    let basePath: String = "/info-posts"
    
    switch self {
    case .upload:
      return basePath
    case let .fetchPostList(dto):
      return basePath + "/categories/\(dto.categoryID)/posts"
    case .fetchBanner:
      return "/featured-posts"
    case .fetchPost(let id):
      return basePath + "/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .upload:
      return .post
    case .fetchPostList, .fetchBanner, .fetchPost:
      return .get
    }
  }
  
  public var sampleData: Data {
    return .init()
  }
  
  public var headers: [String : String]? {
    var headers: [String : String] = [:]
    
    if case .upload = self {
      headers["Content-Type"] = "multipart/form-data"
      headers["Authorization"] = AppProperties.accessToken
    }
    
    return headers
  }
  
  public var task: Task {
    if case .upload(let post) = self {
      return .uploadMultipart(multipartFormData(post))
    }
    
    let requestParam: [String: Any] = parameters ?? [:]
    let encoding: ParameterEncoding
    
    switch self.method {
    case .post, .patch, .put, .delete:
      encoding = JSONEncoding.default
      
    default:
      encoding = URLEncoding.default
    }
    
    return .requestParameters(parameters: requestParam, encoding: encoding)
  }
  
  private var parameters: [String: Any]? {
    switch self {
    case let .fetchPostList(dto):
      return dto.pageable.toDictionary()
    default:
      return nil
    }
  }
}

// MARK: - Private Extenion
private extension PostAPI {
  func multipartFormData(_ post: Post) -> [MultipartFormData] {
    var multipartFormData: [MultipartFormData] = []
    multipartFormData.append(.init(provider: .data(post.imageData), name: "imgFile", fileName: "image.jpg", mimeType: "image/jpeg"))
    
    let postDTO: PostUploadRequestDTO = .init(
      title: post.title,
      categoryID: post.categoryID(),
      organization: post.organization,
      recruitStartDate: post.recruitStartDate,
      recruitEndDate: post.recruitEndDate,
      jobGroups: post.jobGroups,
      activityStartDate: post.activityStartDate,
      activityEndDate: post.activityEndDate,
      activityContents: post.activityContents,
      postUrlString: post.postUrlString
    )
    
    guard let jsonPostDTO = try? JSONEncoder().encode(postDTO),
          let jsonPostDTOString = String(data: jsonPostDTO, encoding: .utf8) else {
      return multipartFormData
    }
    
    multipartFormData.append(.init(provider: .data(jsonPostDTOString.data(using: .utf8)!), name: "infoPostReq"))
    return multipartFormData
  }
}
