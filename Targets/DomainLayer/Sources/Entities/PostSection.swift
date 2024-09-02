//
//  PostSection.swift
//  DomainLayer
//
//  Created by 이원빈 on 8/14/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxDataSources

public struct PostSection: Equatable {
  public let header: String
  public var items: [Item]
}

extension PostSection: SectionModelType {
  public typealias Item = PostCellData
  
  public init(original: PostSection, items: [PostCellData]) {
    self = original
    self.items = items
  }
}

// MARK: - Stub

public extension PostSection {
  static func stub(header: String = "공모전",
                   items: [PostCellData] = [.stub(), .stub(), .stub(), .stub(), .stub()]) -> Self {
    .init(header: header, items: items)
  }
}
