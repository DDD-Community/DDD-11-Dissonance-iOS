//
//  PostKind.swift
//  DomainLayer
//
//  Created by 이원빈 on 1/17/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

public enum PostKind: String, CaseIterable {
  case 공모전
  case 해커톤
  case 동아리
  
  public var id: Int {
    switch self {
    case .공모전: 1
    case .해커톤: 2
    case .동아리: 3
    }
  }
  public var title: String {
    switch self {
    case .공모전: "공모전 📑"
    case .해커톤: "해커톤 🏆"
    case .동아리: "IT 동아리 💻"
    }
  }
  
  public var summary: String {
    switch self {
    case .공모전: "커리어 성장을 위한 IT 공모전 모음"
    case .해커톤: "단기간 프로젝트를 경험할 수 있는 해커톤"
    case .동아리: "사이드 프로젝트 경험을 쌓는 IT 동아리"
    }
  }
}
