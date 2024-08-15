//
//  PostSection.swift
//  DomainLayer
//
//  Created by 이원빈 on 8/14/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxDataSources

public struct PostSection {
  public let header: String
  public var items: [Item]
}

extension PostSection: SectionModelType {
  public typealias Item = Post
  
  public init(original: PostSection, items: [Post]) {
    self = original
    self.items = items
  }
}

// MARK: - Stub

public extension PostSection {
  static func stub(header: String = "공모전",
                   items: [Post] = [.stub(), .stub(), .stub(), .stub(), .stub()]) -> Self {
    .init(header: header, items: items)
  }
}
