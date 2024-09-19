//
//  Post.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation

public struct Post {

  // MARK: Properties
  public var imageData: Data = .init()
  public var title: String = .init()
  public var category: String = .init()
  public var organization: String = .init()
  public var recruitStartDate: String = .init()
  public var recruitEndDate: String = .init()
  public var jobGroups: [JobInformation] = []
  public var activityStartDate: String = .init()
  public var activityEndDate: String = .init()
  public var activityContents: String = .init()
  public var postUrlString: String = .init()
  
  // MARK: - Initializer
  public init() { }
  
  // MARK: - Methods
  public func categoryID() -> Int {
    guard let category = PostUploadCategory(title: category) else {
      return 1
    }
    
    return category.ID
  }
}
