//
//  LoginResponse.swift
//  DataLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct LoginResponse: Decodable {
  
  // MARK: - Properties
  let accessToken, refreshToken: String
  
  // MARK: - Methods
  func makeUserToken() -> UserToken {
    return .init(accessToken: accessToken, refreshToken: refreshToken)
  }
}
