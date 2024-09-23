//
//  BannerCellResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 8/29/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct BannerCellResponse: Decodable {
  let featuredPostID: Int
  let infoPostID: Int
  let bannerImageURL: String
  
  enum CodingKeys: String, CodingKey {
    case featuredPostID = "featuredPostId"
    case infoPostID = "infoPostId"
    case bannerImageURL = "bannerImageUrl"
  }
}

// MARK: - BannerCellResponse + Mapping

public extension BannerCellResponse {
  func toDomain() -> BannerCellData {
    .init(featuredPostID: featuredPostID,
          infoPostID: infoPostID,
          bannerImageURL: bannerImageURL)
  }
}

public extension Array<BannerCellResponse> {
  func toDomain() -> [BannerCellData] {
    self.map { $0.toDomain() }
  }
}
