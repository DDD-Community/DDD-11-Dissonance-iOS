//
//  ContestCategory.swift
//  DomainLayer
//
//  Created by 이원빈 on 9/1/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public enum ContestCategory: String, CaseIterable {
  case all = "전체"
//  case develop = "개발"
  case design = "디자인"
  case idea = "기획·아이디어"
  
  public var id: Int {
    switch self {
    case .all:     return 1
//    case .develop: return 6
    case .design:  return 5
    case .idea:    return 4
    }
  }
}
