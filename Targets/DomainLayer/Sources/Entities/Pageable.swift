//
//  Pageable.swift
//  DomainLayer
//
//  Created by 이원빈 on 9/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation

public struct Pageable: Encodable {
  public let page: Int32
  public let size: Int32
  public let sort: String
  
  public init(page: Int32, size: Int32, sort: String) {
    self.page = page
    self.size = size
    self.sort = sort
  }
}

public extension Pageable {
  static var defaultValue: Self {
    Self.init(
      page: 0,
      size: 30,
      sort: "latest"
    )
  }
}
