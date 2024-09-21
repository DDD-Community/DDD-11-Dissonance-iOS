//
//  JobInformation.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/09/14.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation

public struct JobInformation {
  
  // MARK: - Properties
  public let name: String
  public let count: Int
  
  // MARK: - Initializer
  public init(job: String, count: Int) {
    self.name = job
    self.count = count
  }
}

extension JobInformation: Codable {
  enum CodingKeys: String, CodingKey {
    case name = "positionName"
    case count = "recruitingCount"
  }
}
