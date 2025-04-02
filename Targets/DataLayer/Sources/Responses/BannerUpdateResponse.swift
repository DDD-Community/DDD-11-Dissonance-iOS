//
//  BannerUpdateResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 2/25/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import DomainLayer

public struct BannerUpdateResponse: Decodable {
  let featuredPostID: Int
  let infoPostID: Int
  let bannerImageURL: String
  
  enum CodingKeys: String, CodingKey {
    case featuredPostID = "featuredPostId"
    case infoPostID = "infoPostId"
    case bannerImageURL = "bannerImageUrl"
  }
}

public extension BannerUpdateResponse {
  func toDomain() -> BannerCellData {
    .init(featuredPostID: featuredPostID,
          infoPostID: infoPostID,
          infoPostName: "none",
          bannerImageURL: bannerImageURL)
  }
}
