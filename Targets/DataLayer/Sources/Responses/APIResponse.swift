//
//  APIResponse.swift
//  DataLayer
//
//  Created by 한상진 on 2024/09/14.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation

public struct APIResponse<T: Decodable>: Decodable {
  let statusCode: Int
  let message: String?
  let data: T?
  
  enum CodingKeys: String, CodingKey {
    case statusCode = "code"
    case message = "message"
    case data = "data"
  }
}

public extension APIResponse {
  var isSuccess: Bool {
    (200..<300) ~= statusCode
  }
}
