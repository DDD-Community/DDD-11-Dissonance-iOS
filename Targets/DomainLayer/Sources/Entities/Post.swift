//
//  Post.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Foundation
import MozipCore

public struct Post: Equatable {

  // MARK: Properties
  public let imageData: Data
  public let title: String
  public let categoryTitle: String
  public let organization: String
  public let viewCount: Int
  public let recruitStartDate: String
  public let recruitEndDate: String
  public let jobGroups: [String]
  public let activityStartDate: String
  public let activityEndDate: String
  public let activityContents: String
  public let postUrlString: String
  public let isBookmarked: Bool
  public var category: PostUploadCategory? {
    PostUploadCategory(title: categoryTitle)
  }
  
  public var hasContents: Bool {
    guard !imageData.isEmpty, !jobGroups.contains("") else { return false }
    return ![title, categoryTitle, organization, recruitEndDate, activityContents, postUrlString].contains("")
  }
  
  // MARK: - Initializer
  public init(
    imageData: Data = .init(),
    title: String = .init(),
    categoryTitle: String = .init(),
    organization: String = .init(),
    viewCount: Int = .init(),
    recruitStartDate: String = .init(),
    recruitEndDate: String = .init(),
    jobGroups: [String] = .init(),
    activityStartDate: String = .init(),
    activityEndDate: String = .init(),
    activityContents: String = .init(),
    postUrlString: String = .init(),
    isBookmarked: Bool = .init()
  ) {
    self.imageData = imageData
    self.title = title
    self.categoryTitle = categoryTitle
    self.organization = organization
    self.viewCount = viewCount
    self.recruitStartDate = recruitStartDate
    self.recruitEndDate = recruitEndDate
    self.jobGroups = jobGroups
    self.activityStartDate = activityStartDate
    self.activityEndDate = activityEndDate
    self.activityContents = activityContents
    self.postUrlString = postUrlString
    self.isBookmarked = isBookmarked
  }

  // MARK: - Methods
  public func categoryID() -> Int {
    return category?.ID ?? 1
  }
  
  public func updated(
    imageData: Data? = nil,
    title: String? = nil,
    categoryTitle: String? = nil,
    organization: String? = nil,
    viewCount: Int? = nil,
    recruitStartDate: String? = nil,
    recruitEndDate: String? = nil,
    jobGroups: [String]? = nil,
    activityStartDate: String? = nil,
    activityEndDate: String? = nil,
    activityContents: String? = nil,
    postUrlString: String? = nil,
    isBookmarked: Bool? = nil
  ) -> Post {
    return Post(
      imageData:         imageData ?? self.imageData,
      title:             title ?? self.title,
      categoryTitle:     categoryTitle ?? self.categoryTitle,
      organization:      organization ?? self.organization,
      viewCount:         viewCount ?? self.viewCount,
      recruitStartDate:  recruitStartDate ?? self.recruitStartDate,
      recruitEndDate:    recruitEndDate ?? self.recruitEndDate,
      jobGroups:         jobGroups ?? self.jobGroups,
      activityStartDate: activityStartDate ?? self.activityStartDate,
      activityEndDate:   activityEndDate ?? self.activityEndDate,
      activityContents:  activityContents ?? self.activityContents,
      postUrlString:     postUrlString ?? self.postUrlString,
      isBookmarked:      isBookmarked ?? self.isBookmarked
    )
  }
  
  /// 날짜 데이터 4개(활동 시작일, 활동 마감일, 모집 시작일, 모집 마감일)의 포맷은
  /// Response로 받을 땐 yyyy.MM.dd 형태로 받아짐.
  /// Request로 보낼 땐 yyyy년 MM월 dd일 형태로 보내야 함.
  /// PostEdit에서 사용하기 위해 날짜 포맷을 변환하는 메서드
  public func mapDateValuesToRequestFormat() -> Post {
    return updated(
      recruitStartDate:  translateToRequestFormat(for: recruitStartDate),
      recruitEndDate:    translateToRequestFormat(for: recruitEndDate),
      activityStartDate: translateToRequestFormat(for: activityStartDate),
      activityEndDate:   translateToRequestFormat(for: activityEndDate)
    )
  }
  
  public func mapDateValuesToResponseFormat() -> Post {
    return updated(
      recruitStartDate:  translateToResponseFormat(for: recruitStartDate),
      recruitEndDate:    translateToResponseFormat(for: recruitEndDate),
      activityStartDate: translateToResponseFormat(for: activityStartDate),
      activityEndDate:   translateToResponseFormat(for: activityEndDate)
    )
  }
  
  private func translateToRequestFormat(for dateValue: String) -> String {
    guard !dateValue.isEmpty else { return "" }
    let date = DateFormatter.yyyyMMddResponseFormat.date(from: dateValue) ?? .init()
    return DateFormatter.yyyyMMddRequestFormat.string(from: date)
  }
  
  private func translateToResponseFormat(for dateValue: String) -> String {
    guard !dateValue.isEmpty else { return "" }
    let date = DateFormatter.yyyyMMddRequestFormat.date(from: dateValue) ?? .init()
    return DateFormatter.yyyyMMddResponseFormat.string(from: date)
  }
}
