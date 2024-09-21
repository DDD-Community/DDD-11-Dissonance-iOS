//
//  PostCellResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 9/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct PostCellResponse: Decodable {
  let id: Int
  let imgUrl, title, remainingDays: String
}

// MARK: - PostCellResponse + Mapping

public extension PostCellResponse {
  func toDomain() -> PostCellData {
    .init(id: id,
          imageURL: imgUrl,
          title: title,
          remainTag: remainingDays)
  }
}

public extension Array<PostCellResponse> {
  func toDomain() -> [PostCellData] {
    self.map { $0.toDomain() }
  }
}

public struct PostCellListResponse: Decodable {
  let content: [PostCellResponse]
  
  func toDomain() -> [PostCellData] {
    content.map { $0.toDomain() }
  }
}
