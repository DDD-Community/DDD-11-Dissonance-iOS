//
//  BannerCellResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 8/29/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct BannerCellResponse: Decodable {
  let featuredPostId, infoPostId: Int
  let bannerImageUrl: String
}

/*
 {
   "featuredPostId": 1,
   "bannerImageUrl": "https://naver.com",
   "infoPostId": 1
 }
 */

// MARK: - BannerCellResponse + Mapping

public extension BannerCellResponse {
  func toDomain() -> BannerCellData {
    .init(featuredPostId: featuredPostId,
          infoPostId: infoPostId,
          bannerImageUrl: bannerImageUrl)
  }
}

public extension Array<BannerCellResponse> {
  func toDomain() -> [BannerCellData] {
    self.map { $0.toDomain() }
  }
}
