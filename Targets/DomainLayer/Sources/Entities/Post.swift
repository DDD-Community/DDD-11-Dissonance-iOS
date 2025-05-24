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
  public var imageData: Data = .init()
  public var title: String = .init()
  public var categoryTitle: String = .init()
  public var organization: String = .init()
  public var viewCount: Int = .init()
  public var recruitStartDate: String = .init()
  public var recruitEndDate: String = .init()
  public var jobGroups: [String] = []
  public var activityStartDate: String = .init()
  public var activityEndDate: String = .init()
  public var activityContents: String = .init()
  public var postUrlString: String = .init()
  public var isBookmarked: Bool = .init()
  public var category: PostUploadCategory? {
    PostUploadCategory(title: categoryTitle)
  }
  
  // MARK: - Initializer
  public init() { }
  
  // MARK: - Methods
  public func categoryID() -> Int {
    guard let category else { return 1 }
    
    return category.ID
  }
  
  /// 날짜 데이터 4개(활동 시작일, 활동 마감일, 모집 시작일, 모집 마감일)의 포맷은
  /// Response로 받을 땐 yyyy.MM.dd 형태로 받아짐.
  /// Request로 보낼 땐 yyyy년 MM월 dd일 형태로 보내야 함.
  /// PostEdit에서 사용하기 위해 날짜 포맷을 변환하는 메서드
  public mutating func mapDateValuesToRequestFormat() {
    recruitStartDate = translateToRequestFormat(for: recruitStartDate)
    recruitEndDate = translateToRequestFormat(for: recruitEndDate)
    activityStartDate = translateToRequestFormat(for: activityStartDate)
    activityEndDate = translateToRequestFormat(for: activityEndDate)
  }
  
  public static func == (lhs: Post, rhs: Post) -> Bool {
    lhs.title == rhs.title &&
    lhs.organization == rhs.organization &&
    lhs.postUrlString == rhs.postUrlString
  }
  
  private func translateToRequestFormat(for dateValue: String) -> String {
    guard !dateValue.isEmpty else { return "" }
    let date = DateFormatter.yyyyMMdd_ResponseFormat.date(from: dateValue) ?? .init()
    return DateFormatter.yyyyMMdd_RequestFormat.string(from: date)
  }
}
