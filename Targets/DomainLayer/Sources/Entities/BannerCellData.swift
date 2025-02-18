//
//  BannerCellData.swift
//  DomainLayer
//
//  Created by 이원빈 on 8/29/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation

public struct BannerCellData: Equatable {
  public let featuredPostID, infoPostID: Int
  public let bannerImageURL: String
  
  public init(
    featuredPostID: Int,
    infoPostID: Int,
    bannerImageURL: String
  ) {
    self.featuredPostID = featuredPostID
    self.infoPostID = infoPostID
    self.bannerImageURL = bannerImageURL
  }
}

extension BannerCellData {
  public static func stub(featuredPostID: Int = 0,
                   infoPostID: Int = 0,
                   bannerImageURL: String = "www.naver.com") -> Self {
    .init(featuredPostID: featuredPostID,
          infoPostID: infoPostID,
          bannerImageURL: bannerImageURL)
  }
  
  public func toRecommendCellData() -> RecommendCellData {
    .init(featuredPostID: featuredPostID,
          infoID: infoPostID,
          title: "",
          subTitle: "부제목",
          thumbnailURL: bannerImageURL)
  }
}
