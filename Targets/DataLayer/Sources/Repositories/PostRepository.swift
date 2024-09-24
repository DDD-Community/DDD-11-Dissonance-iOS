//
//  PostRepository.swift
//  DataLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

import Moya
import RxMoya
import RxSwift

public final class PostRepository: PostRepositoryType {
  
  // MARK: - Properties
  private let provider: MoyaProvider<PostAPI>
  
  // MARK: - Initializer
  init(provider: MoyaProvider<PostAPI> = MoyaProvider<PostAPI>()) {
    self.provider = provider
  }
  
  // MARK: - Methods
  public func upload(_ post: Post) -> Single<(isSuccess: Bool, message: String?)> {
    return provider.rx.request(.upload(post))
      .map(APIResponse<PostUploadResponse>.self)
      .map { (isSuccess: $0.isSuccess, message: $0.message) }
  }

  public func fetchPostList(categoryId: Int, pageable: Pageable) -> Single<[PostCellData]> {
    let postListFetchRequestDTO = PostListFetchRequestDTO(
      categoryID: categoryId,
      pageable: pageable
    )
    
    return provider.rx.request(.fetchPostList(postListFetchRequestDTO))
      .map(APIResponse<PostCellListResponse>.self)
      .map {
        guard let data = $0.data else { return [] }
        return data.toDomain()
      }
  }
  
  public func fetchBanner() -> Single<[BannerCellData]> {
    provider.rx.request(.fetchBanner)
      .map(APIResponse<[BannerCellResponse]>.self)
      .map {
        guard let data = $0.data else { return [] }
        return data.toDomain()
      }
  }
  
  public func fetchPost(id: Int) -> Single<(isSuccess: Bool, post: Post)> {
    return provider.rx.request(.fetchPost(id: id))
      .map(APIResponse<PostDetailResponse>.self)
      .flatMap { response -> Single<(isSuccess: Bool, post: Post)> in
        guard let responseData = response.data else {
          return .just((isSuccess: response.isSuccess, post: .init()))
        }
        
        return .create { single in
          responseData.toPost { post in
            single(.success((isSuccess: response.isSuccess, post: post)))
          }
          return Disposables.create()
        }
      }
  }
  
  public func report(id: Int) -> Single<(isSuccess: Bool, message: String?)> {
    return provider.rx.request(.report(id: id))
      .map(APIResponse<String>.self)
      .map { (isSuccess: $0.isSuccess, message: $0.message) }
  }
}
