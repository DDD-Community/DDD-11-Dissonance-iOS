//
//  BannerResponse.swift
//  DataLayer
//
//  Created by 이원빈 on 8/29/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation

public struct BannerResponse: Decodable {
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
