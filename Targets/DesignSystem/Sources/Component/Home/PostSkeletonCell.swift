//
//  PostSkeletonCell.swift
//  DesignSystem
//
//  Created by 한상진 on 1/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout

public final class PostSkeletonCell: UICollectionViewCell {
  
  // MARK: - Properties
  private enum Metric {
    static let verticalSpacing: CGFloat = 8
    static let labelHeight: CGFloat = 16
    static let remainDayHeight: CGFloat = 24
  }
  
  private let thumbnailImageSkeletonView = SkeletonView() 
  private let titleLabelSkeletonView1 = SkeletonView()
  private let titleLabelSkeletonView2 = SkeletonView()
  private let remainDayTagSkeletonView = SkeletonView()
  
  // MARK: - Initializer
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Drawing Cycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.flex.layout()
  }
}

// MARK: - Private Extenion
private extension PostSkeletonCell {
  func setupViews() {
    contentView.flex
      .gap(Metric.verticalSpacing)
      .define {
        $0.addItem(thumbnailImageSkeletonView).width(100%).aspectRatio(1)
        $0.addItem(titleLabelSkeletonView1).height(Metric.labelHeight)
        $0.addItem(titleLabelSkeletonView2).height(Metric.labelHeight)
        $0.addItem(remainDayTagSkeletonView).width(30%).height(Metric.remainDayHeight)
      }
  }
}
