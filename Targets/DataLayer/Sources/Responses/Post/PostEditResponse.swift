//
//  PostEditResponse.swift
//  DataLayer
//
//  Created by 한상진 on 11/18/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

public struct PostEditResponse: Decodable {
  let title: String
  let categoryName: String 
  let organization: String
  let recruitmentPeriod: String
  let positionInfos: [String]
  let activityPeriod: String?
  let content: String
  let detailURL: String
  let viewCount: Int
  let imageURL: String
  let isBookmarked: Bool?
  
  enum CodingKeys: String, CodingKey {
    case title, categoryName, organization, positionInfos, activityPeriod, content, isBookmarked
    case detailURL = "detailUrl"
    case viewCount
    case imageURL = "imageUrl"
    case recruitmentPeriod
  }
}
