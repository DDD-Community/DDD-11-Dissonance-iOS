//
//  MyPageUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/09/23.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol MyPageUseCaseType {
  
  // MARK: - Properties
  var userRepository: UserRepositoryType { get }
  
  // MARK: - Methods
  func deleteAccount() -> Observable<MozipNetworkResult>
  func logout() -> Observable<MozipNetworkResult>
}

final class MyPageUseCase: MyPageUseCaseType {
  
  // MARK: - Properties
  let userRepository: UserRepositoryType
  private let disposeBag: DisposeBag = .init()
  
  // MARK: - Initializer
  init(userRepository: UserRepositoryType) {
    self.userRepository = userRepository
  }
  
  // MARK: - Methods
  func deleteAccount() -> Observable<MozipNetworkResult> {
    return userRepository.delete()
      .asObservable()
      .map { _ -> MozipNetworkResult in .success }
      .catchAndReturnNetworkError()
  }
  
  func logout() -> Observable<MozipNetworkResult> {
    return userRepository.logout()
      .asObservable()
      .map { _ -> MozipNetworkResult in .success }
      .catchAndReturnNetworkError()
  }
}
