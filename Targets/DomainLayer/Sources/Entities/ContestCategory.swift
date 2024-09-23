//
//  ContestCategory.swift
//  DomainLayer
//
//  Created by 이원빈 on 9/1/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

public enum ContestCategory: String, CaseIterable {
  case all = "전체"
  case idea = "아이디어·기획"
  case design = "디자인"
  case develop = "개발·IT"
  
  public var id: Int {
    switch self {
    case .all:     return 1
    case .idea:    return 4
    case .design:  return 5
    case .develop: return 6
    }
  }
}
