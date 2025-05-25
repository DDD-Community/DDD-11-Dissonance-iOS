//
//  DateFormatterUtil.swift
//  MozipCore
//
//  Created by 이원빈 on 5/24/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

final public class DateFormatterUtil {
  private static var cachedFormatters: [String: DateFormatter] = [:]
  private static let lock = NSLock()
  
  public static func formatter(
    format: String,
    locale: Locale = .current,
    timeZone: TimeZone = .current
  ) -> DateFormatter {
      
    lock.lock()
    defer { lock.unlock() }
    
    if let formatter = cachedFormatters[format] {
      formatter.locale = locale
      formatter.timeZone = timeZone
      return formatter
    }
    
    let formatter = DateFormatter().builder
      .dateFormat(format)
      .locale(locale)
      .timeZone(timeZone)
      .build()
    
    cachedFormatters[format] = formatter
    return formatter
  }
}

/*
 DateFormatter 는 초기화 비용이 많이 든다. Date 타입 -> String 타입으로 변경할 때마다 DateFormatter 를 초기화시키는 것을
 방지하기 위해 dictionary cache 를 이용하여 불필요한 초기화를 방지해주는 클래스
 */
