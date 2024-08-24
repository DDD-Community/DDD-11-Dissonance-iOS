//
//  Post.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public struct Post {

  // MARK: Properties
  public var imageData: Data = .init()
  public var title: String = .init()
  public var category: String = .init()
  public var organization: String = .init()
  public var recruitStartDate: String = .init()
  public var recruitEndDate: String = .init()
  public var jobGroups: [(job: String, count: Int)] = []
  public var activityStartDate: String = .init()
  public var activityEndDate: String = .init()
  public var activityContents: String = .init()
  public var postUrlString: String = .init()
  
  public init() { }
}

// TODO: 서버 연동 후 제거 예정
public extension Post {
  static func stub() -> Self {
    var stub: Self = .init()
    
    if let stubImagePath = Bundle.main.path(forResource: "StubImage", ofType: "jpeg") {
      let url = URL(fileURLWithPath: stubImagePath)
      stub.imageData = try! Data(contentsOf: url)
    }
    stub.title = "DDD 12기 모집"
    stub.category = "3"
    stub.organization = "IT 연합동아리 DDD"
    stub.recruitStartDate = "2024년 8월 25일"
    stub.recruitEndDate = "2050년 8월 26일"
    stub.jobGroups = [(job: "웹 프론트엔드", count: 20), (job: "백엔드", count: 20), (job: "iOS 개발", count: 20), (job: "AOS 개발", count: 20), (job: "디자인", count: 20), (job: "기획", count: 20)]
    stub.activityStartDate = "2099년 8월 25일"
    stub.activityEndDate = "2099년 8월 26일"
    stub.activityContents = """
DDD는 Dynamic Designer Developer 디자인, 개발이 성장하고 발전하는 열정적인 날들의 의미를 함축하고 있는 그룹으로, IT 업계의 개발자와 디자이너들을 위한 모임입니다.
DDD는 Dynamic Designer Developer 디자인, 개발이 성장하고 발전하는 열정적인 날들의 의미를 함축하고 있는 그룹으로, IT 업계의 개발자와 디자이너들을 위한 모임입니다.
"""
    stub.postUrlString = "https://dddset.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F74278ccf-ea4a-4885-a832-43c79a9f5e14%2Fad885b7a-8ff6-41a0-a636-99618934eab4%2F11%25E1%2584%2580%25E1%2585%25B5_%25E1%2584%2586%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25B5%25E1%2586%25B8.jpeg?table=block&id=22a76616-8ec4-46ab-8223-4e981d34844a&spaceId=74278ccf-ea4a-4885-a832-43c79a9f5e14&width=1440&userId=&cache=v2"
    
    return stub
  }
}
