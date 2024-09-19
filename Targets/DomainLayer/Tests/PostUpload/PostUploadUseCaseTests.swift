//
//  PostUploadUseCaseTests.swift
//  DDD-11-Dissonance-iOSManifests
//
//  Created by 한상진 on 2024/07/11.
//

import RxSwift
import XCTest
@testable import DomainLayer

final class PostUploadUseCaseTests: XCTestCase {
  
  // MARK: - Properties
  private var mockPostRepository: MockPostRepository!
  private var postUploadUseCase: PostUploadUseCaseType!
  private var disposeBag: DisposeBag!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    
    mockPostRepository = MockPostRepository()
    disposeBag = DisposeBag()
    postUploadUseCase = PostUploadUseCase(postRepository: mockPostRepository)
  }
  
  override func tearDown() {
    disposeBag = nil
    mockPostRepository = nil
    postUploadUseCase = nil
    
    super.tearDown()
  }
  
  // MARK: - Methods
  func test_게시글_업로드_성공() {
    // Given
    let post: Post = .init()
    var result: PostUploadResult?
    let expectation: XCTestExpectation = .init(description: "게시글 업로드 성공")
    
    // When
    mockPostRepository.setupUploadResult(isSuccess: true, message: nil)
    
    postUploadUseCase.execute(with: post)
      .bind { uploadResult in
        result = uploadResult
        expectation.fulfill()
      }
      .disposed(by: disposeBag)
    
    // Then
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(result, .success)
  }
  
  func test_게시글_업로드_실패() {
    // Given
    let post: Post = .init()
    let errorMessage = "게시글 업로드 실패"
    var result: PostUploadResult?
    let expectation: XCTestExpectation = .init(description: "게시글 업로드 실패")
    
    // When
    mockPostRepository.setupUploadResult(isSuccess: false, message: errorMessage)
    
    postUploadUseCase.execute(with: post)
      .bind { uploadResult in
        result = uploadResult
        expectation.fulfill()
      }
      .disposed(by: disposeBag)
    
    // Then
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(result, .error(message: errorMessage))
  }
}
