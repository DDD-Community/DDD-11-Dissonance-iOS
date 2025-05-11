//
//  UserUseCase.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/09/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift

public protocol UserUseCaseType {
  
  // MARK: - Properties
  var userRepository: UserRepositoryType { get }
  
  // MARK: - Methods
  func fetchUserInformation() -> Observable<(isAdmin: Bool, provider: String)>
  func fetchBookmarkList(pageable: Pageable) -> Observable<[BookmarkCellData]>
}

final class UserUseCase: UserUseCaseType {
  
  // MARK: - Properties
  let userRepository: UserRepositoryType
  private let disposeBag: DisposeBag = .init()
  
  // MARK: - Initializer
  init(userRepository: UserRepositoryType) {
    self.userRepository = userRepository
  }
  
  // MARK: - Methods
  func fetchUserInformation() -> Observable<(isAdmin: Bool, provider: String)> {
    return userRepository.fetchInformation()
      .asObservable()
  }
  
  func fetchBookmarkList(pageable: Pageable) -> Observable<[BookmarkCellData]> {
    return userRepository.fetchBookmarkList(pageable: pageable)
      .asObservable()
  }
}
