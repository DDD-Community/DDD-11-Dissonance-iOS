//
//  PostCellData.swift
//  DomainLayer
//
//  Created by 이원빈 on 8/7/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

public struct PostCellData: Equatable {
  public let id: Int
  public let imageURL: String
  public let title: String
  public let remainTag: String
  
  public init(
    id: Int,
    imageURL: String,
    title: String,
    remainTag: String
  ) {
    self.id = id
    self.imageURL = imageURL
    self.title = title
    self.remainTag = remainTag
  }
}

// MARK: - Stub

public extension PostCellData {
  static func stub(id: Int = 0,
                   imageURL: String = "",
                   title: String = "2024년 미디어 온라인 홍보단 2기 모집",
                   remainTag: String = "D-1") -> Self {
    .init(id: id,
          imageURL: imageURL,
          title: title,
          remainTag: remainTag)
  }
}

// MARK: - toPostSection

public extension Array<PostCellData> {
  func toPostSection(header: String, summary: String) -> PostSection {
    .init(header: header, summary: summary, items: self)
  }
}
