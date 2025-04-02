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
  public let infoPostName, bannerImageURL: String
  
  public init(
    featuredPostID: Int,
    infoPostID: Int,
    infoPostName: String,
    bannerImageURL: String
  ) {
    self.featuredPostID = featuredPostID
    self.infoPostID = infoPostID
    self.infoPostName = infoPostName
    self.bannerImageURL = bannerImageURL
  }
}

extension BannerCellData {
  public static func stub(featuredPostID: Int = 0,
                   infoPostID: Int = 0,
                   bannerImageURL: String = "www.naver.com") -> Self {
    .init(featuredPostID: featuredPostID,
          infoPostID: infoPostID,
          infoPostName: "",
          bannerImageURL: bannerImageURL)
  }
  
  public func toRecommendCellData() -> RecommendCellData {
    .init(featuredPostID: featuredPostID,
          infoID: infoPostID,
          title: "",
          subTitle: infoPostName,
          thumbnailURL: bannerImageURL)
  }
}
