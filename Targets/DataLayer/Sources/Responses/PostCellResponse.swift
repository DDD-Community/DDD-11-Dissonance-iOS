//
//  PostCellResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 9/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct PostCellResponse: Decodable {
  let id, viewCount: Int
  let imgUrl, title, remainingDays: String
}

// MARK: - PostCellResponse + Mapping

public extension PostCellResponse {
  func toDomain() -> PostCellData {
    .init(id: id,
          imageURL: imgUrl,
          title: title,
          remainTag: remainingDays,
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
  let last: Bool // FIXME: 마지막 페이지인지 여부, 추후 페이징처리에 활용
  
  func toDomain() -> [PostCellData] {
    content.map { $0.toDomain() }
  }
}
