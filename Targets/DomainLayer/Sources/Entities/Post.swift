//
//  Post.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public struct Post {

  // MARK: Properties
  public var imageData: Data = .init()
  public var title: String = .init()
  public var category: String = .init()
  public var organization: String = .init()
  public var recruitStartDate: String = .init()
  public var recruitEndDate: String = .init()
  public var jobGroups: [(job: String, count: Int)] = []
  public var activityStartDate: String = .init()
  public var activityEndDate: String = .init()
  public var activityContents: String = .init()
  public var postUrlString: String = .init()
  
  public init() { }
}
