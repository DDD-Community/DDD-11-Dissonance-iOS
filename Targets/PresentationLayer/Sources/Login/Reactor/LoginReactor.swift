//
//  LoginReactor.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import MozipCore
import DomainLayer

import ReactorKit

final class LoginReactor: Reactor {

  // MARK: - Properties
  private let loginUseCase: LoginUseCaseType
  private let userUseCase: UserUseCaseType
  var initialState: State = .init()

  // MARK: - Initializer
  init(loginUseCase: LoginUseCaseType, userUseCase: UserUseCaseType) {
    self.loginUseCase = loginUseCase
    self.userUseCase = userUseCase
  }

  enum Action {
    case didTapKakaoLoginButton
    case didTapAppleLoginButton
    case fetchUserInfo
  }

  enum Mutation {
    case setUserToken(userToken: UserToken)
    case setUserInfo(isAdmin: Bool, provider:String)
  }

  struct State {
    var isSuccessLogin: Bool = false
    var didFinish: Bool = false
  }

  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapKakaoLoginButton:
      return loginUseCase.tryKakaoLogin().map { .setUserToken(userToken: $0) }
    case .didTapAppleLoginButton:
      return loginUseCase.tryAppleLogin().map { .setUserToken(userToken: $0) }
    case .fetchUserInfo:
      return fetchUserInfo()
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
      
    case let .setUserInfo(isAdmin, provider):
      saveUserInfo(isAdmin: isAdmin, provider: provider)
      newState.didFinish = true
    }

    return newState
  }
}

// MARK: - Private Extenion
private extension LoginReactor {
  func fetchUserInfo() -> Observable<Mutation> {
    userUseCase.fetchUserInformation()
      .flatMap { Observable<Mutation>.just(.setUserInfo(isAdmin: $0.isAdmin, provider: $0.provider)) }
  }
  
  func saveUserInfo(isAdmin: Bool, provider: String) {
    guard let isAdminData = "\(isAdmin)".data(using: .utf8),
          let providerData = provider.data(using: .utf8)
    else { fatalError() }
    
    AuthManager.save(authInfoType: .isAdmin, data: isAdminData)
    AuthManager.save(authInfoType: .provider, data: providerData)
  }
}
