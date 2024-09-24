//
//  PostDetailResponse.swift
//  DataLayer
//
//  Created by 한상진 on 2024/09/22.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer
import Foundation

public struct PostDetailResponse: Decodable {
  let imageURL: String
  let title: String
  let category: String
  let organization: String
  let recruitmentPeriod: String
  let jobGroups: [JobInformation]
  let activityPeriod: String
  let content: String
  let postUrlString: String
  let viewCount: Int
  
  enum CodingKeys: String, CodingKey {
    case imageURL = "imageUrl"
    case title
    case category = "categoryName"
    case organization
    case recruitmentPeriod
    case jobGroups = "positionInfos"
    case activityPeriod
    case content
    case postUrlString = "detailUrl"
    case viewCount
  }
}

public extension PostDetailResponse {
  func toPost() -> Post {
    var post: Post = .init()
    
    post.imageData = postImageData()
    post.title = title
    post.category = category
    post.organization = organization
    (post.recruitStartDate, post.recruitEndDate) = periodComponents(recruitmentPeriod)
    post.jobGroups = jobGroups
    (post.activityStartDate, post.activityEndDate) = periodComponents(activityPeriod)
    post.activityContents = content
    post.postUrlString = postUrlString
    
    return post
  }
}

private extension PostDetailResponse {
  func postImageData() -> Data {
    // TODO: KingFisher 적용 예정
    guard let imageURL = URL(string: imageURL),
          let imageData = try? Data(contentsOf: imageURL) else {
      return .init()
    }
    
    return imageData
  }
  
  func periodComponents(_ period: String) -> (startDate: String, endDate: String) {
    let splitComponents = period.components(separatedBy: " ~ ")
    return (startDate: splitComponents[0], endDate: splitComponents[1])
  }
}
