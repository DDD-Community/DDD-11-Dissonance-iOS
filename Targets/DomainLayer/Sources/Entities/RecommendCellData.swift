//
//  RecommendCellData.swift
//  PresentationLayer
//
//  Created by 이원빈 on 2/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

public struct RecommendCellData: Equatable, Codable {
  public var featuredPostID: Int
  public var infoID: Int
  public var title: String
  public var subTitle: String
  public var thumbnailURL: String
  public var imageData: Data?
  
  public init(
    featuredPostID: Int,
    infoID: Int,
    title: String,
    subTitle: String,
    thumbnailURL: String,
    imageData: Data? = nil
  ) {
    self.featuredPostID = featuredPostID
    self.infoID = infoID
    self.title = title
    self.subTitle = subTitle
    self.thumbnailURL = thumbnailURL
    self.imageData = imageData
  }
}

public extension RecommendCellData {
  
  static var initialData: [Self] = [
    .init(featuredPostID: 1, infoID: 0, title: "첫 번째 추천", subTitle: " ", thumbnailURL: ""),
    .init(featuredPostID: 2, infoID: 0, title: "두 번째 추천", subTitle: " ", thumbnailURL: ""),
    .init(featuredPostID: 3, infoID: 0, title: "세 번째 추천", subTitle: " ", thumbnailURL: ""),
    .init(featuredPostID: 4, infoID: 0, title: "네 번째 추천", subTitle: " ", thumbnailURL: ""),
    .init(featuredPostID: 5, infoID: 0, title: "다섯 번째 추천", subTitle: " ", thumbnailURL: "")
  ]
  
  var isUploadAvailable: Bool {
    infoID != 0 &&
    subTitle.isEmpty == false &&
    subTitle != " " &&
    imageData != nil
  }
  
  var isChanged: Bool {
    (subTitle != " " && subTitle.isEmpty == false) ||
    imageData != nil
  }
}
