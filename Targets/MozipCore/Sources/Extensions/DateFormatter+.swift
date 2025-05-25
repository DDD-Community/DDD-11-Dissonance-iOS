//
//  DateFormatter+.swift
//  MozipCore
//
//  Created by 이원빈 on 5/25/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

// MARK: - 자주쓰이는 포맷 미리 정의
public extension DateFormatter {
  static let yyyyMMddResponseFormat = DateFormatterUtil.formatter(format: "yyyy.MM.dd")
  static let yyyyMMddRequestFormat = DateFormatterUtil.formatter(format: "yyyy년 MM월 dd일")
}
