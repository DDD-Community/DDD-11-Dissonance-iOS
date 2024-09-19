//
//  MockPostRepository.swift
//  DomainLayerTests
//
//  Created by 한상진 on 2024/09/19.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxSwift
@testable import DomainLayer

final class MockPostRepository: PostRepositoryType {
  
  // MARK: - Properties
  private var uploadResult: Single<(isSuccess: Bool, message: String?)>!
  
  // MARK: - Methods
  func setupUploadResult(isSuccess: Bool, message: String?) {
    uploadResult = .just((isSuccess: isSuccess, message: message))
  }
  
  func upload(_ post: Post) -> Single<(isSuccess: Bool, message: String?)> {
    return uploadResult
  }
}
