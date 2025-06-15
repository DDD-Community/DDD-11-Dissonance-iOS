//
//  PostDetailResponse.swift
//  DataLayer
//
//  Created by 한상진 on 2024/09/22.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer
import Foundation

import Kingfisher

public struct PostDetailResponse: Decodable {
  let imageURL: String
  let title: String
  let category: String
  let organization: String
  let recruitmentPeriod: String
  let jobGroups: [String]
  let activityPeriod: String?
  let content: String
  let postUrlString: String
  let viewCount: Int
  let isBookmarked: Bool
  
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
    case isBookmarked
  }
}

public extension PostDetailResponse {
  func toPost(completion: @escaping (Post) -> Void) {
    postImageData { imageData in
      let (postRecruitStartDate, postRecruitEndDate) = periodComponents(recruitmentPeriod)
      let (postActivityStartDate, postActivityEndDate) = periodComponents(activityPeriod)
      
      let post = Post(
        imageData: imageData,
        title: title,
        categoryTitle: category,
        organization: organization,
        viewCount: viewCount,
        recruitStartDate: postRecruitStartDate,
        recruitEndDate: postRecruitEndDate,
        jobGroups: jobGroups,
        activityStartDate: postActivityStartDate,
        activityEndDate: postActivityEndDate,
        activityContents: content,
        postUrlString: postUrlString,
        isBookmarked: isBookmarked 
      )
      completion(post)
    }
  }
}

private extension PostDetailResponse {
  func postImageData(completion: @escaping (Data) -> Void) {
    guard  let imageURL = URL(string: imageURL) else {
      completion(.init())
      return
    }
    
    KingfisherManager.shared.downloader.downloadImage(with: imageURL) { result in
      switch result {
      case .success(let value):
        let imageData = value.image.pngData() ?? Data()
        completion(imageData)
      case .failure:
        completion(.init())
      }
    }
  }
  
  func periodComponents(_ period: String?) -> (startDate: String, endDate: String) {
    guard let period = period else {
      return ("", "")
    }
    let splitComponents = period.components(separatedBy: " ~ ")
    return (startDate: splitComponents[0], endDate: splitComponents[1])
  }
}
