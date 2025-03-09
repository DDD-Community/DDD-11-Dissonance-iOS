//
//  UserDefaultWrapper.swift
//  MozipCore
//
//  Created by 이원빈 on 2/15/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefaultWrapper<T: Codable> {
  private let key: String
  private let defaultValue: T
  
  public init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  public var wrappedValue: T {
    get {
      if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
        let decoder = JSONDecoder()
        if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
          return lodedObejct
        }
      }
      return defaultValue
    }
    set {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(newValue) {
        UserDefaults.standard.setValue(encoded, forKey: key)
      }
    }
  }
}
