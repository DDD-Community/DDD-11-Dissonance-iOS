//
//  LoginRepositoryType.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol LoginRepositoryType {

  // MARK: Methods
  func tryKakaoLogin() -> Observable<UserToken>
}
