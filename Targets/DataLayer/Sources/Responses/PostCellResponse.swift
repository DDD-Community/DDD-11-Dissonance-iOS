//
//  PostCellResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 9/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct PostCellResponse: Decodable {
  let id, viewCount, bookmarkCount: Int
  let imgUrl, title, remainingDays: String
}

// MARK: - PostCellResponse + Mapping

public extension PostCellResponse {
  func toDomain() -> PostCellData {
    .init(id: id,
          imageURL: imgUrl,
          title: title,
          remainTag: remainingDays,
          bookmarkCount: bookmarkCount,
          viewCount: viewCount)
  }
}

public extension Array<PostCellResponse> {
  func toDomain() -> [PostCellData] {
    self.map { $0.toDomain() }
  }
}

public struct PostCellListResponse: Decodable {
  let content: [PostCellResponse]
  let totalElements: Int
  let last: Bool
  
  func toDomain() -> PostPage {
    .init(posts: content.toDomain(),
          totalElements: totalElements,
          last: last)
  }
}
