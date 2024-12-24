//
//  Logger.swift
//  Core
//
//  Created by 한상진 on 11/9/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import os

public enum Logger {
  public static func log(message: String) {
    os_log("\(message)")
  }
}
