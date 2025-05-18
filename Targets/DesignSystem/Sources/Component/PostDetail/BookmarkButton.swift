//
//  BookmarkButton.swift
//  DesignSystem
//
//  Created by 한상진 on 5/16/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout

public final class BookmarkButton: UIButton {
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    imageView?.pin.size(37.5%).center()
  }
  
  // MARK: - Methods
  public func setBookmarked(_ isBookmarked: Bool) {
    let image = isBookmarked ? 
    DesignSystemAsset.bookmarkFill.image : DesignSystemAsset.bookmark.image.withTintColor(MozipColor.gray400)
    setImage(image, for: .normal)
  }
}

// MARK: - Private Extenion
private extension BookmarkButton {
  func setupView() {
    backgroundColor = MozipColor.gray10
    flex.cornerRadius(8)
  }
}
