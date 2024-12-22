//
//  PostListSearchRequestDTO.swift
//  DataLayer
//
//  Created by 이원빈 on 12/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct PostListSearchRequestDTO: Encodable {
  public let keyword: String
  public let pageable: Pageable
}
