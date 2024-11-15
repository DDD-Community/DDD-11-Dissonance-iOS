//
//  Reactive+.swift
//  DataLayer
//
//  Created by 한상진 on 11/9/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core

import Moya
import RxSwift

public extension Reactive where Base: MoyaProviderType {
  
  // MARK: Methods
  func request<T: Decodable>(_ target: Base.Target, type: T.Type) -> Single<Response> {
    Single.create { [weak base] single in
      let cancellableToken = base?.request(target, callbackQueue: nil, progress: nil) { result in
        switch result {
        case let .success(response):
          single(.success(response))
          
          if let apiResponse = try? response.map(APIResponse<T>.self) {
            let logMessage = """
                          🚨URL: \(String(describing: response.request?.url))
                          🚨code: \(apiResponse.statusCode), 
                          🚨message: \(String(describing: apiResponse.message)), 
                          🚨data: \(String(describing: apiResponse.data))
                          """
            Logger.log(message: logMessage)
          }
          
        case let .failure(error):
          single(.failure(error))
          Logger.log(message: error.localizedDescription)
        }
      }
      
      return Disposables.create {
        cancellableToken?.cancel()
      }
    }
  }
}
