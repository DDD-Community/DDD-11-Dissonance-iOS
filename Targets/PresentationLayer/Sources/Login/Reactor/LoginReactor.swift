//
//  LoginReactor.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import DomainLayer

import ReactorKit

final class LoginReactor: Reactor {

  // MARK: - Properties
  private let loginUseCase: LoginUseCaseType
  var initialState: State = .init()
  var isFirstLogin: Bool = AuthManager.load(authInfoType: .isFirstLogin) == nil

  // MARK: - Initializer
  init(loginUseCase: LoginUseCaseType) {
    self.loginUseCase = loginUseCase
  }

  enum Action {
    case didTapKakaoLoginButton
    case didTapAppleLoginButton
  }

  enum Mutation {
    case setUserToken(userToken: UserToken)
  }

  struct State {
    var isSuccessLogin: Bool = false
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapKakaoLoginButton:
      return loginUseCase.tryKakaoLogin().map { .setUserToken(userToken: $0) }
    case .didTapAppleLoginButton:
      return loginUseCase.tryAppleLogin().map { .setUserToken(userToken: $0) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setUserToken(let userToken):
      
      //TODO: 추후 예외처리 구현 예정
      guard let accessTokenData = userToken.accessToken.data(using: .utf8),
            let refreshTokenData = userToken.refreshToken.data(using: .utf8)
      else { fatalError() }

      AuthManager.save(authInfoType: .accessToken, data: accessTokenData)
      AuthManager.save(authInfoType: .refreshToken, data: refreshTokenData)
      newState.isSuccessLogin = true
    }

    return newState
  }
}
