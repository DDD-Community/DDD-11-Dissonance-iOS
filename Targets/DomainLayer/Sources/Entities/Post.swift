//
//  Post.swift
//  DomainLayer
//
//  Created by 이원빈 on 8/7/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation

public struct Post {
  public let imageURL: String
  public let title: String
  public let remainTag: String
  
  public init(imageURL: String, title: String, remainTag: String) {
    self.imageURL = imageURL
    self.title = title
    self.remainTag = remainTag
  }
}

public extension Post {
  
  static func stub(imageURL: String = "",
                   title: String = "2024년 미디어 온라인 홍보단 2기 모집",
                   remainTag: String = "D-1") -> Self {
    .init(imageURL: imageURL,
          title: title,
          remainTag: remainTag)
  }
}
