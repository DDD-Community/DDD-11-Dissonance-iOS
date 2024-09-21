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
  var uploadResultSingle: Single<(isSuccess: Bool, message: String?)>!
  
  func upload(_ post: Post) -> Single<(isSuccess: Bool, message: String?)> {
    return uploadResultSingle
  }
}
