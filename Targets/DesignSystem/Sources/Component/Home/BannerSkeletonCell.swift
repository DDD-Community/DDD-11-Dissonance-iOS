//
//  BannerSkeletonCell.swift
//  DesignSystem
//
//  Created by 한상진 on 1/5/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit

import PinLayout

public final class BannerSkeletonCell: UICollectionViewCell {
  
  // MARK: - Properties
  private let bannerSkeletonView = SkeletonView()
  
  // MARK: - Initializer
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(bannerSkeletonView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Drawing Cycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    bannerSkeletonView.pin.all()
  }
}
