//
//  RecommendCellData.swift
//  PresentationLayer
//
//  Created by 이원빈 on 2/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

public struct RecommendCellData: Equatable, Codable {
  public var infoID: Int
  public var title: String
  public var subTitle: String
  public var thumbnailURL: String
  public var imageData: Data?
  
  public init(infoID: Int, title: String, subTitle: String, thumbnailURL: String, imageData: Data? = nil) {
    self.infoID = infoID
    self.title = title
    self.subTitle = subTitle
    self.thumbnailURL = thumbnailURL
    self.imageData = imageData
  }
}

public extension RecommendCellData {
  static var dummy: Self {
    .init(
      infoID: 0,
      title: "첫 번째 추천",
      subTitle: "제 2회 하나카드 plate 디자인 공모전",
      thumbnailURL: "https://itit-bucket.s3.ap-northeast-2.amazonaws.com/info-posts/%E1%84%8B%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%83%E1%85%B5%E1%84%8B%E1%85%A5%E1%84%90%E1%85%A9%E1%86%AB.png",
      imageData: nil
    )
  }
  
  static var initialData: [Self] = [
    .init(infoID: 0, title: "첫 번째 추천", subTitle: "부제목", thumbnailURL: ""),
    .init(infoID: 0, title: "두 번째 추천", subTitle: "부제목", thumbnailURL: ""),
    .init(infoID: 0, title: "세 번째 추천", subTitle: "부제목", thumbnailURL: ""),
    .init(infoID: 0, title: "네 번째 추천", subTitle: "부제목", thumbnailURL: ""),
    .init(infoID: 0, title: "다섯 번째 추천", subTitle: "부제목", thumbnailURL: "")
  ]
  
  var isUploadAvailable: Bool {
    infoID != 0 &&
    subTitle.isEmpty == false &&
    subTitle != "부제목" &&
    imageData != nil
  }
  
  var isChanged: Bool {
    (subTitle != "" && subTitle != "부제목") ||
    imageData != nil
  }
}
