//
//  CoordinatorTests.swift
//  PresentationLayerTests
//
//  Created by 한상진 on 2024/07/11.
//

import XCTest
@testable import PresentationLayer

final class CoordinatorTests: XCTestCase {
  
  // MARK: - Properties
  private var parentCoordinator: MockCoordinatorType!
  private var childCoordinator: MockCoordinatorType!
  
  // MARK: - Initializer
  override func setUp() {
    super.setUp()
    
    parentCoordinator = MockCoordinator()
    childCoordinator = MockCoordinator()
  }
  
  override func tearDown() {
    parentCoordinator = nil
    childCoordinator = nil
    
    super.tearDown()
  }
  
  // MARK: - Methods
  func test_자식코디네이터_추가() {
    // When
    parentCoordinator.addChild(childCoordinator)
    
    // Then
    XCTAssertEqual(parentCoordinator.childCoordinators.count, 1)
    XCTAssertTrue(parentCoordinator.childCoordinators.first === childCoordinator)
  }
  
  func test_자식코디네이터_제거() {
    // When
    parentCoordinator.addChild(childCoordinator)
    parentCoordinator.removeChild(childCoordinator)
    
    // Then
    XCTAssertEqual(parentCoordinator.childCoordinators.count, 0)
    XCTAssertNil(childCoordinator.parentCoordinator)
  }
  
  func test_시작메서드_호출() {
    // When
    childCoordinator.start()
    
    // Then
    XCTAssertTrue(childCoordinator.startCalled)
  }
  
  func test_완료메서드_호출() {
    // Given
    let coordinator = MockCoordinator()
    
    // When
    coordinator.didFinish()
    
    // Then
    XCTAssertTrue(coordinator.didFinishCalled)
  }
}
