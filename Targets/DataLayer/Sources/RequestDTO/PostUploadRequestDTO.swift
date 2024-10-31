//
//  PostUploadRequestDTO.swift
//  DataLayer
//
//  Created by 한상진 on 2024/09/14.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct PostUploadRequestDTO: Encodable {
  
  // MARK: Properties
  public var title: String
  public var categoryID: Int
  public var organization: String
  public var recruitStartDate: String
  public var recruitEndDate: String
  public var jobGroups: [String]
  public var activityStartDate: String
  public var activityEndDate: String
  public var activityContents: String
  public var postUrlString: String
  
  enum CodingKeys: String, CodingKey {
    case title = "title"
    case categoryID = "categoryId"
    case organization = "organization"
    case recruitStartDate = "recruitmentStartDate"
    case recruitEndDate = "recruitmentEndDate"
    case jobGroups = "positionInfos"
    case activityStartDate = "activityStartDate"
    case activityEndDate = "activityEndDate"
    case activityContents = "content"
    case postUrlString = "detailUrl"
  }
}
