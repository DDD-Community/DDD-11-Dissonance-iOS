//
//  ObservableType+.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/09/21.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public extension ObservableType where Element == MozipNetworkResult {
  
  // MARK: - Methods
  func catchAndReturnNetworkError() -> Observable<Element> {
    catchAndReturn(MozipNetworkResult.error(message: "네트워크 오류가 발생했습니다."))
  }
}
