//
//  LoginUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol LoginUseCaseType {
  var loginRepository: LoginRepositoryType { get }
  
  func tryKakaoLogin() -> Observable<UserToken>
}

extension LoginUseCaseType {
  func tryKakaoLogin() -> Observable<UserToken> {
    loginRepository.tryKakaoLogin()
  }
}

final class LoginUseCase: LoginUseCaseType {
  
  // MARK: - Properties
  let loginRepository: LoginRepositoryType
  
  // MARK: - Initializer
  init(loginRepository: LoginRepositoryType) {
    self.loginRepository = loginRepository
  }
}
