//
//  UserRepositoryType.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/09/23.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol UserRepositoryType {
  
  // MARK: Methods
  func regenerate() -> Single<UserToken>
  func information() -> Single<(isAdmin: Bool, provider: String)>
  func delete() -> Single<Void>
  func logout() -> Single<Void>
}
