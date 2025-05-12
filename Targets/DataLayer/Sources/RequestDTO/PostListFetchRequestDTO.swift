//
//  PostListFetchRequestDTO.swift
//  DataLayer
//
//  Created by 이원빈 on 9/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

public struct PostListFetchRequestDTO: Encodable {
  public let categoryID: Int /// 1: 공모전, 2: 교육, 3: 동아리, 4: 아이디어기획, 5: 디자인, 6: 개발IT
  public let pageable: Pageable
}
