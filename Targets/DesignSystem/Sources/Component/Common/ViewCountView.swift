//
//  ViewCountView.swift
//  DesignSystem
//
//  Created by 한상진 on 12/11/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout

public final class ViewCountView: UIView {
  
  // MARK: - Properties
  private let imageView: UIImageView = {
    let imageView: UIImageView = .init(image: DesignSystemAsset.viewCountIcon.image)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let countLabel: MozipLabel = .init(style: .caption1, color: MozipColor.gray400)
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  public func setupCountLabel(_ count: Int) {
    countLabel.updateTextKeepingAttributes(String(count))
  }
  
  public func markDirty() {
    countLabel.flex.markDirty()
  }
}

// MARK: - Private Extenion
private extension ViewCountView {
  func setupLayout() {
    flex
      .direction(.row)
      .define {
        $0.addItem(imageView)
        $0.addItem(countLabel).marginLeft(4)
      }
  }
}
