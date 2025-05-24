//
//  PropertyBuilder.swift
//  MozipCore
//
//  Created by 이원빈 on 5/24/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

@dynamicMemberLookup
public struct PropertyBuilder<Base> {
  
  private let base: Base
  
  public init(_ base: Base) {
    self.base = base
  }
  
  public subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> (Value) -> PropertyBuilder<Base> {
    return { [base] value in
      var object = base
      object[keyPath: keyPath] = value
      return PropertyBuilder(object)
    }
  }
  
  public subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> (Value) -> Base {
    return { [base] value in
      var object = base
      object[keyPath: keyPath] = value
      return object
    }
  }
  
  public func set<Value>(_ keyPath: WritableKeyPath<Base, Value>, to value: Value) -> PropertyBuilder<Base> {
    var object = self.base
    object[keyPath: keyPath] = value
    return PropertyBuilder(object)
  }
  
  public func build() -> Base {
    return self.base
  }
}

public extension PropertyBuilder {
  func with(_ handler: (inout Base) -> Void) -> PropertyBuilder<Base> {
    PropertyBuilder(self.with(handler))
  }
  
  func with(_ handler: (inout Base) -> Void) -> Base {
    var object = self.base
    handler(&object)
    return object
  }
}
