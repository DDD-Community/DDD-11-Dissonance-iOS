//
//  PostUploadRepository.swift
//  DataLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

import Moya
import RxMoya
import RxSwift

public final class PostUploadRepository: PostUploadRepositoryType {
  
  // MARK: - Properties
  private let provider: MoyaProvider<PostUploadAPI>
  
  // MARK: - Initializer
  init(provider: MoyaProvider<PostUploadAPI> = MoyaProvider<PostUploadAPI>()) {
    self.provider = provider
  }
}
