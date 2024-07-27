//
//  LoginRepository.swift
//  DataLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

import Moya
import RxMoya
import RxKakaoSDKUser
import RxSwift
import KakaoSDKUser
import KakaoSDKAuth

public final class LoginRepository: LoginRepositoryType {

  // MARK: - Properties
  private let provider: MoyaProvider<LoginAPI>

  // MARK: - Initializer
  init(provider: MoyaProvider<LoginAPI> = MoyaProvider<LoginAPI>()) {
    self.provider = provider
  }

  // MARK: - Methods
  public func tryKakaoLogin() -> Observable<UserToken> {
    let isInstalledKakaoTalk: Bool = UserApi.isKakaoTalkLoginAvailable()
    let loginRequest: Observable<OAuthToken> = (
      isInstalledKakaoTalk ? UserApi.shared.rx.loginWithKakaoTalk() : UserApi.shared.rx.loginWithKakaoAccount()
    )
    
    return loginRequest
      .withUnretained(self)
      .flatMap { owner, oAuthToken in
        owner.requestKakaoLogin(accessToken: oAuthToken.accessToken)
      }
  }
}

// MARK: - Extension
private extension LoginRepository {
  func requestKakaoLogin(accessToken: String) -> Single<UserToken> {
    provider.rx.request(.tryKakaoLogin(accessToken: accessToken))
      .map(LoginResponse.self)
      .map { $0.makeUserToken() }
  }
}
