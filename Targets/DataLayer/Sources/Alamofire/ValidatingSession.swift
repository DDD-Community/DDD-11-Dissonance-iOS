//
//  ValidatingSession.swift
//  DataLayer
//
//  Created by 한상진 on 3/28/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation

import Alamofire

final class ValidatingSession: Session {
  override func request(
    _ convertible: any URLRequestConvertible,
    interceptor: (any RequestInterceptor)? = nil
  ) -> DataRequest {
    return super.request(
      convertible,
      interceptor: interceptor
    ).validate(statusCode: 200..<300)
  }
  
  override func upload(
    multipartFormData: MultipartFormData,
    with request: any URLRequestConvertible,
    usingThreshold encodingMemoryThreshold: UInt64 = MultipartFormData.encodingMemoryThreshold,
    interceptor: (any RequestInterceptor)? = nil,
    fileManager: FileManager = .default
  ) -> UploadRequest {
    return super.upload(
      multipartFormData: multipartFormData,
      with: request,
      usingThreshold: encodingMemoryThreshold,
      interceptor: interceptor,
      fileManager: fileManager
    ).validate(statusCode: 200..<300)
  }
}
