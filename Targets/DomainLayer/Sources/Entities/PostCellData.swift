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
  public let viewCount: Int
  
  public init(
    id: Int,
    imageURL: String,
    title: String,
    remainTag: String,
    viewCount: Int
  ) {
    self.id = id
    self.imageURL = imageURL
    self.title = title
    self.remainTag = remainTag
    self.viewCount = viewCount
  }
}

// MARK: - Stub

public extension PostCellData {
  static func stub(id: Int = 0,
                   imageURL: String = "",
                   title: String = "2024년 미디어 온라인 홍보단 2기 모집",
                   remainTag: String = "D-1",
                   viewCount: Int = 123) -> Self {
    .init(id: id,
          imageURL: imageURL,
          title: title,
          remainTag: remainTag,
          viewCount: viewCount)
  }
}

// MARK: - toPostSection

public extension Array<PostCellData> {
  func toPostSection(kind: PostKind) -> PostSection {
    .init(kind: kind, items: self)
  }
}
