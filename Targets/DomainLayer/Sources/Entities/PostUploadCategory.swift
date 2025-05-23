//
//  PostUploadCategory.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/09/14.
//  Copyright © 2024 MOZIP. All rights reserved.
//

public enum PostUploadCategory {
  case contestPlan
  case contestDesign
  case contestIT
  case education
  case club
  
  public init?(title: String) {
    switch title {
    case "공모전 - 아이디어·기획", "아이디어·기획": self = .contestPlan
    case "공모전 - 디자인", "디자인": self = .contestDesign
    case "공모전 - 개발·IT", "개발·IT": self = .contestIT
    case "교육": self = .education
    case "IT 동아리": self = .club
    default: return nil
    }
  }
  
  public var title: String {
    switch self {
    case .contestPlan: "공모전 - 아이디어·기획"
    case .contestDesign: "공모전 - 디자인"
    case .contestIT: "공모전 - 개발·IT"
    case .education: "교육"
    case .club: "IT 동아리"
    }
  }
  
  public var ID: Int {
    switch self {
    case .contestPlan: 4
    case .contestDesign: 5
    case .contestIT: 6
    case .education: 2
    case .club: 3
    }
  }
}
