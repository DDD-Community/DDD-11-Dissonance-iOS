//
//  BookmarkResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 5/11/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import DomainLayer

public struct BookmarkResponse: Decodable {
  let postId: Int
  let title, remainingDays, deadLine: String
  
  func toDomain() -> BookmarkCellData {
    .init(id: postId, remainDayTag: remainingDays, remainDayDescription: deadLine, title: title)
  }
}

public extension Array<BookmarkResponse> {
  func toDomain() -> [BookmarkCellData] {
    self.map { $0.toDomain() }
  }
}
