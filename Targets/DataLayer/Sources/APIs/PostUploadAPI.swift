//
//  PostUploadAPI.swift
//  DataLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import DomainLayer
import Foundation

import Moya

enum PostUploadAPI {
  case uploadPost(_ post: Post)
}

// MARK: - TargetType
extension PostUploadAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  //TODO: API 문서 전달받은 후 구현 예정
  var path: String {
    return ""
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

  //TODO: API 문서 전달받은 후 구현 예정
  private var parameters: [String: Any]? {
    return nil
  }
}
