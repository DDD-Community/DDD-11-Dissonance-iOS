//
//  PostOrder.swift
//  DomainLayer
//
//  Created by 이원빈 on 9/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

public enum PostOrder: String {
  case latest
  case deadline
  
  public var title: String {
    switch self {
    case .latest:   "최신순"
    case .deadline: "마감순"
    }
  }
}
