//
//  PostSkeletonHeader.swift
//  DesignSystem
//
//  Created by 한상진 on 1/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

public final class PostSkeletonHeader: UICollectionReusableView {
  
  // MARK: - Properties
  private enum Metric {
    static let buttonSpacing: CGFloat = 4
  }
  
  private let rootFlexContainer = UIView()
  private let sectionTitleSkeletonView = SkeletonView()
  private let sectionSummarySkeletonView = SkeletonView()
  private let buttonSkeletonView = SkeletonView()
  
  // MARK: - Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - DrawingCycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
  
}
// MARK: - Private Extenion
private extension PostSkeletonHeader {
  func setupViews() {
    addSubview(rootFlexContainer)
    
    rootFlexContainer.flex
      .height(92)
      .define {
        $0.addDivider(height: 8, color: MozipColor.gray10)
        
        $0.addItem()
          .marginTop(36)
          .height(22)
          .marginHorizontal(20)
          .direction(.row)
          .define {
            $0.addItem(sectionTitleSkeletonView).width(20%)
            $0.addItem().grow(1)
            
            $0.addItem(buttonSkeletonView)
              .width(20%)
              .marginRight(20)
          }
        
        $0.addItem(sectionSummarySkeletonView)
          .marginTop(8)
          .width(40%)
          .height(20)
          .marginLeft(20)
      }
  }
}
