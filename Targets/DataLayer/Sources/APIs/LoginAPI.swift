//
//  LoginAPI.swift
//  DataLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import MozipCore
import Foundation

import Moya

enum LoginAPI {
  case tryKakaoLogin(accessToken: String)
  case tryAppleLogin(jwt: String)
}

// MARK: - TargetType
extension LoginAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  var path: String {
    let basePath = "/oauth"

    switch self {
    case .tryKakaoLogin:
      return basePath + "/kakao"
    case .tryAppleLogin:
      return basePath + "/apple"
    }
  }

  var method: Moya.Method {
    return .post
  }

  public var sampleData: Data {
    return .init()
  }

  public var headers: [String : String]? {
    return [:]
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
    case .tryKakaoLogin(let accessToken):
      return ["accessToken": accessToken]
    case .tryAppleLogin(let jwt):
      return ["accessToken": jwt]
    }
  }
}
