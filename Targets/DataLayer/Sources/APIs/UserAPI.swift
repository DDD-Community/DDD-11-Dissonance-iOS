//
//  UserAPI.swift
//  DataLayer
//
//  Created by 한상진 on 2024/09/23.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import MozipCore
import DomainLayer
import Foundation

import Moya

enum UserAPI {
  case information
  case regenerate
  case delete
  case logout
}

// MARK: - TargetType
extension UserAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  var path: String {
    let basePath = "/users"

    switch self {
    case .information: return basePath
    case .regenerate: return basePath + "/reissue"
    case .delete: return basePath
    case .logout: return basePath + "/logout"
    }
  }

  var method: Moya.Method {
    switch self {
    case .information: return .get
    case .regenerate: return .post
    case .delete: return .delete
    case .logout: return .get
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
    case .regenerate: return ["refreshToken": AppProperties.refreshToken]
    case .logout: return ["Authorization": AppProperties.accessToken]
    default: return nil
    }
  }
}
