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
  public let summary: String
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
                   summary: String = "커리어 성장을 위한 IT 공모전 모음",
                   items: [PostCellData] = [.stub(), .stub(), .stub(), .stub(), .stub()]) -> Self {
    .init(header: header, summary: summary, items: items)
  }
}
