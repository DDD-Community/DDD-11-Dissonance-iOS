//
//  RecommendedPostStream.swift
//  PresentationLayer
//
//  Created by 이원빈 on 2/12/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Foundation
import DomainLayer

import RxCocoa

public protocol RecommendedPostStream {
  var data: BehaviorRelay<[RecommendCellData]> { get set }
  var targetIndex: Int { get set }
}

public protocol MutableRecommendedPostStream: RecommendedPostStream {
  func setTargetIndex(_ index: Int)
  func updatePostInfo(id: Int, subTitle: String)
  func updatePostImage(_ imageData: Data)
  func updateAllPost(posts: [RecommendCellData])
}

final class MutableRecommendedPostStreamImpl: MutableRecommendedPostStream {
  
  var data: BehaviorRelay<[RecommendCellData]> = .init(
    value: RecommendCellData.initialData
  )
  var targetIndex: Int = 0
  
  func setTargetIndex(_ index: Int) {
    targetIndex = index
  }
  
  func updatePostInfo(id: Int, subTitle: String) {
    var currentList = data.value
    var targetPost = currentList[targetIndex]
    targetPost.infoID = id
    targetPost.subTitle = subTitle
    currentList[targetIndex] = targetPost
    data.accept(currentList)
  }
  
  func updatePostImage(_ imageData: Data) {
    var currentList = data.value
    var targetPost = currentList[targetIndex]
    targetPost.imageData = imageData
    currentList[targetIndex] = targetPost
    data.accept(currentList)
  }
  
  func updateAllPost(posts: [RecommendCellData]) {
    var currentList = data.value
    currentList.enumerated().forEach { (i, item) in
      currentList[i].infoID = posts[i].infoID
      currentList[i].subTitle = posts[i].subTitle
      currentList[i].thumbnailURL = posts[i].thumbnailURL
      currentList[i].imageData = posts[i].imageData
    }
    data.accept(currentList)
  }
}
