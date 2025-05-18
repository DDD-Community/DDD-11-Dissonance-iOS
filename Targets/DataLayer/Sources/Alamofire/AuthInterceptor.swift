//
//  AuthInterceptor.swift
//  DataLayer
//
//  Created by 한상진 on 2/14/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation
import MozipCore

import Alamofire
import Moya
import RxSwift

struct AuthInterceptor: RequestInterceptor {
  
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  
  // MARK: - Methods
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    guard let response = request.response, response.statusCode == 401 else {
      completion(.doNotRetry)
      return
    }
    
    refreshAccessToken()
      .subscribe(
        onCompleted: {
          completion(.retry)
        },
        onError: { error in
          completion(.doNotRetry)
          AuthManager.deleteTokens()
          NotificationCenter.default.post(name: .logout, object: nil)
        }
      )
      .disposed(by: disposeBag)
  }
}

// MARK: - Private Extenion
private extension AuthInterceptor {
  func refreshAccessToken() -> Completable {
    let userProvider = MoyaProvider<UserAPI>(session: ValidatingSession())
    
    return Completable.create { completable in
      let disposable = userProvider.rx.request(.regenerate)
        .map(APIResponse<LoginResponse>.self)
        .subscribe(
          onSuccess: { response in
            let accessTokenData = response.data?.accessToken.data(using: .utf8) ?? Data()
            let refreshTokenData = response.data?.refreshToken.data(using: .utf8) ?? Data()
            AuthManager.deleteTokens()
            AuthManager.save(authInfoType: .accessToken, data: accessTokenData)
            AuthManager.save(authInfoType: .refreshToken, data: refreshTokenData)
            completable(.completed)
          },
          onFailure: { error in
            completable(.error(error))
          }
        )
      
      return Disposables.create {
        disposable.dispose()
      }
    }
  }
}
