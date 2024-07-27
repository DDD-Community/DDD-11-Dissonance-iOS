//
//  UserToken.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

public struct UserToken {

  // MARK: Properties
  public let accessToken: String
  public let refreshToken: String


  // MARK: Initializer
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
