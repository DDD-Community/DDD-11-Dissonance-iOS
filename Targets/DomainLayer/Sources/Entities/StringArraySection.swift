//
//  StringArraySection.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/30.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import RxDataSources

public struct StringArraySection: Equatable {

  // MARK: Properties
  public let header: String
  public var items: [String]
  
  // MARK: - Initializer
  public init(header: String, items: [String]) {
    self.header = header
    self.items = items
  }
}

extension StringArraySection: SectionModelType {

  // MARK: Initializer
  public init(original: StringArraySection, items: [String]) {
    self = original
    self.items = items
  }
}
