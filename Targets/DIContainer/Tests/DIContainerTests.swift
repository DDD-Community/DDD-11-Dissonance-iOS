//
//  DIContainerTests.swift
//  DIContainerTests
//
//  Created by 한상진 on 2024/07/26.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import XCTest
@testable import DIContainer

final class DIContainerTests: XCTestCase {
  private var mockDIContainer: DIContainable!
  
  override func setUp() {
    super.setUp()
    
    mockDIContainer = MockDIContainer()
  }
  
  override func tearDown() {
    mockDIContainer = nil
    
    super.tearDown()
  }
  
  // MARK: - Methods
  func test_의존성객체의_등록과_반환() {
    
    // Given
    let mockServiceType = MockServiceType.self
    let mockService = MockService()
    
    // When
    mockDIContainer.register(type: mockServiceType) { _ in mockService }
    let resolvedService = mockDIContainer.resolve(type: mockServiceType)
    
    // Then
    XCTAssertNotNil(resolvedService, "반환받은 객체는 nil일 수 없습니다.")
  }
  
  func test_등록되지_않은_의존성객체_반환() {
    // Given
    let unregisteredServiceType = MockServiceType.self
    
    // When
    let resolvedService = mockDIContainer.resolve(type: unregisteredServiceType)
    
    // Then
    XCTAssertNil(resolvedService, "등록하지 않은 객체는 nil이 반환되어야 합니다.")
  }
  
  func test_컨테이너_싱글톤_확인() {
    // Given
    let container1 = DIContainer.shared
    let container2 = DIContainer.shared
    
    // Then
    XCTAssertTrue(container1 === container2, "DIContainer는 싱글톤 인스턴스여야 합니다.")
  }
  
  func test_반환받은_객체의_작동확인() {
    // Given
    let mockServiceType = MockServiceType.self
    let mockService = MockService()
    
    // When
    mockDIContainer.register(type: mockServiceType) { _ in mockService }
    
    guard let resolvedService = mockDIContainer.resolve(type: mockServiceType) else {
      XCTFail("반환받은 객체는 nil일 수 없습니다.")
      return
    }
    resolvedService.performAction()
    
    // Then
    XCTAssertTrue(resolvedService.actionCalled)
  }
}
