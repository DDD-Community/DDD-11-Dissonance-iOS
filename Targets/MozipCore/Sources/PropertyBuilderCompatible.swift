//
//  PropertyBuilderCompatible.swift
//  MozipCore
//
//  Created by 이원빈 on 5/24/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

public protocol PropertyBuilderCompatible {
  associatedtype Base
  var builder: PropertyBuilder<Base> { get }
}

public extension PropertyBuilderCompatible {
  var builder: PropertyBuilder<Self> {
    PropertyBuilder(self)
  }
}

extension NSObject: PropertyBuilderCompatible {}
