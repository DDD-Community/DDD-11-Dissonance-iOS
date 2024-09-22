//
//  UserInformationResponse.swift
//  DataLayer
//
//  Created by 한상진 on 2024/09/23.
//  Copyright © 2024 MOZIP. All rights reserved.
//

struct UserInformationResponse: Decodable {
  let isAdmin: Bool
  let provider: String
}
