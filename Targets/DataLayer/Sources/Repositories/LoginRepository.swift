//
//  LoginRepository.swift
//  DataLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import AuthenticationServices
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
  private let appleLoginManager = AppleLoginManager()

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
  
  public func tryAppleLogin() -> Observable<UserToken> {
    appleLoginManager.signInWithApple()
    
    return appleLoginManager.appleLoginSubject
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, asauthorization in
        owner.requestAppleLogin(jwt: owner.parseJWT(from: asauthorization))
      }
  }
}

// MARK: - Extension
private extension LoginRepository {
  func requestKakaoLogin(accessToken: String) -> Single<UserToken> {
    provider.rx.request(.tryKakaoLogin(accessToken: accessToken))
      .map(APIResponse<LoginResponse>.self)
      .map { $0.data?.makeUserToken() ?? .init(accessToken: "", refreshToken: "") }
  }
  
  func requestAppleLogin(jwt: String) -> Single<UserToken> {
    provider.rx.request(.tryAppleLogin(jwt: jwt))
      .map(APIResponse<LoginResponse>.self)
      .map { $0.data?.makeUserToken() ?? .init(accessToken: "", refreshToken: "") }
  }
  
  func parseJWT(from authorization: ASAuthorization) -> String {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      guard let jwtData = appleIDCredential.identityToken,
            let jwtString = String(data: jwtData, encoding: .utf8) else {
        return "NULL"
      }
      return jwtString
    case let passwordCredential as ASPasswordCredential:
      let userIdentifier = passwordCredential.user
      return userIdentifier
    default:
      return "NULL"
    }
  }
}
