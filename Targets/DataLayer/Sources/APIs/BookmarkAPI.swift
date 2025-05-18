//
//  BookmarkAPI.swift
//  DataLayer
//
//  Created by 한상진 on 5/16/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import DomainLayer
import MozipCore
import Foundation

import Moya

enum BookmarkAPI {
  case toggle(id: Int)
  case fetchBookmarkList(Pageable)
}

// MARK: - TargetType
extension BookmarkAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }
  
  var path: String {
    let basePath = "/bookmarks"
    
    switch self {
    case .toggle(let id): return basePath + "/\(id)" + "/toggle"
    case .fetchBookmarkList: return basePath
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .toggle: return .post
    case .fetchBookmarkList: return .get
    }
  }
  
  public var sampleData: Data {
    return .init()
  }
  
  public var headers: [String : String]? {
    return ["Authorization": AppProperties.accessToken]
  }
  
  public var task: Task {
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
    case .toggle: return nil
    case .fetchBookmarkList(let pageable): return pageable.toDictionary()
    }
  }
}
