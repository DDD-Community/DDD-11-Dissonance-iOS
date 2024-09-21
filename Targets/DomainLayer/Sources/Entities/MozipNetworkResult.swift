//
//  MozipNetworkResult.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/09/21.
//  Copyright © 2024 MOZIP. All rights reserved.
//

public enum MozipNetworkResult: Error, Equatable {
  case success
  case error(message: String?)
}
