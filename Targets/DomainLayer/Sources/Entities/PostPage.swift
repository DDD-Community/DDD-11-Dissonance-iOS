//
//  PostPage.swift
//  DomainLayer
//
//  Created by 이원빈 on 6/8/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

public struct PostPage: Equatable {
  public let posts: [PostCellData]
  public let totalElements: Int // 공고의 총 개수
  public let last: Bool // 마지막 페이지 여부
  
  public init(posts: [PostCellData], totalElements: Int, last: Bool) {
    self.posts = posts
    self.totalElements = totalElements
    self.last = last
  }
  
  public static let empty = PostPage(posts: [], totalElements: 0, last: true)
}
