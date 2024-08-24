//
//  PostCellData.swift
//  DomainLayer
//
//  Created by 이원빈 on 8/7/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

public struct PostCellData {
  public let imageURL: String
  public let title: String
  public let remainTag: String
}

// MARK: - Stub

public extension PostCellData {
  static func stub(imageURL: String = "",
                   title: String = "2024년 미디어 온라인 홍보단 2기 모집",
                   remainTag: String = "D-1") -> Self {
    .init(imageURL: imageURL,
          title: title,
          remainTag: remainTag)
  }
}
