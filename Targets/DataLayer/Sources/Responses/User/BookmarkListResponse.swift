//
//  BookmarkListResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 5/11/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation
import DomainLayer

public struct BookmarkListResponse: Decodable {
  let hasNest: Bool
  let content: [BookmarkResponse]
  
  func toDomain() -> [BookmarkCellData] {
    // TODO: hasNest 를 고려한 모델 Mapping 로직은 추후 페이지네이션 기능 적용 시 작성
    return content.toDomain()
  }
}
