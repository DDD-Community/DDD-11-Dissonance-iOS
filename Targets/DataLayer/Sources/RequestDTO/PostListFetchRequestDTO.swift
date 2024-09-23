//
//  PostListFetchRequestDTO.swift
//  DataLayer
//
//  Created by 이원빈 on 9/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct PostListFetchRequestDTO: Encodable {
  public let categoryID: Int
  public let pageable: Pageable
}
