//
//  BannerUpdateRequestDTO.swift
//  DataLayer
//
//  Created by 이원빈 on 2/17/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

public struct BannerUpdateRequestDTO: Encodable {
  public let featuredPostId: Int
  public let infoPostId: Int
  public let imgFile: Data
  
  public init(featuredPostId: Int, infoPostId: Int, imgFile: Data) {
    self.featuredPostId = featuredPostId
    self.infoPostId = infoPostId
    self.imgFile = imgFile
  }
}
