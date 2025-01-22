//
//  PostKind.swift
//  DomainLayer
//
//  Created by 이원빈 on 1/17/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

public enum PostKind: String, CaseIterable {
  case contest
  case hackathon
  case club
  
  public var id: Int {
    switch self {
    case .contest: 1
    case .hackathon: 2
    case .club: 3
    }
  }
  
  public var navigationTitle: String {
    switch self {
    case .contest: "공모전"
    case .hackathon: "해커톤"
    case .club: "IT 동아리"
    }
  }
  
  public var sectionTitle: String {
    switch self {
    case .contest: "공모전 📑"
    case .hackathon: "해커톤 🏆"
    case .club: "IT 동아리 💻"
    }
  }
  
  public var summary: String {
    switch self {
    case .contest: "커리어 성장을 위한 IT 공모전 모음"
    case .hackathon: "단기간 프로젝트를 경험할 수 있는 해커톤"
    case .club: "사이드 프로젝트 경험을 쌓는 IT 동아리"
    }
  }
}
