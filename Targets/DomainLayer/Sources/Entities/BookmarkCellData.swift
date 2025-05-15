//
//  BookmarkCellData.swift
//  DomainLayer
//
//  Created by 이원빈 on 5/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

public struct BookmarkCellData: Equatable {
  public let id: Int
  public let remainDayTag: String // "D-13"
  public let remainDayDescription: String // "10월 3일 마감"
  public let title: String // "DDD 동아리 11기 모집 공고"
  
  public init(
    id: Int,
    remainDayTag: String,
    remainDayDescription: String,
    title: String
  ) {
    self.id = id
    self.remainDayTag = remainDayTag
    self.remainDayDescription = remainDayDescription
    self.title = title
  }
}

extension BookmarkCellData {
  
  public static func stub(
    id: Int,
    remainDayTag: String,
    remainDayDescription: String,
    title: String
  ) -> Self {
    .init(
      id: id,
      remainDayTag: remainDayTag,
      remainDayDescription: remainDayDescription,
      title: title
    )
  }
}
