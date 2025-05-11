//
//  UserRepository.swift
//  DataLayer
//
//  Created by 한상진 on 2024/09/23.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

import Moya
import RxMoya
import RxSwift

public final class UserRepository: UserRepositoryType {
  
  // MARK: - Properties
  private let provider: MoyaProvider<UserAPI>
  
  // MARK: - Initializer
  init(provider: MoyaProvider<UserAPI> = MoyaProvider<UserAPI>()) {
    self.provider = provider
  }
  
  // MARK: - Methods
  public func fetchInformation() -> Single<(isAdmin: Bool, provider: String)> {
    return provider.rx.request(.information)
      .map(APIResponse<UserInformationResponse>.self)
      .map { (isAdmin: $0.data?.isAdmin ?? false, provider: $0.data?.provider ?? "") }
  }
  
  public func regenerate() -> Single<UserToken> {
    return provider.rx.request(.regenerate)
      .map(APIResponse<LoginResponse>.self)
      .map { $0.data?.makeUserToken() ?? .init(accessToken: "", refreshToken: "") }
  }
  
  public func delete() -> Single<Void> {
    return provider.rx.request(.delete)
      .map(APIResponse<String>.self)
      .map { _ in }
  }
  
  public func logout() -> Single<Void> {
    return provider.rx.request(.logout)
      .map(APIResponse<String>.self)
      .map { _ in }
  }
  
  public func fetchBookmarkList(pageable: Pageable) -> Single<[BookmarkCellData]> { // FIXME: 추후 BookmarkRepository 분리
    return provider.rx.request(.fetchBookmarkList(pageable))
      .map(APIResponse<BookmarkListResponse>.self)
      .map {
        guard let data = $0.data else { return [] }
        return data.toDomain()
      }
  }
}
