//
//  BannerCellData.swift
//  DomainLayer
//
//  Created by 이원빈 on 8/29/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation

public struct BannerCellData: Equatable {
  public let featuredPostId, infoPostId: Int
  public let bannerImageUrl: String
}

extension BannerCellData {
  public static func stub(featuredPostId: Int = 0,
                   infoPostId: Int = 0,
                   bannerImageUrl: String = "www.naver.com") -> Self {
    .init(featuredPostId: featuredPostId,
          infoPostId: infoPostId,
          bannerImageUrl: bannerImageUrl)
  }
}
