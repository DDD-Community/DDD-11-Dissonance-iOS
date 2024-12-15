//
//  FABSubButton.swift
//  DesignSystem
//
//  Created by 이원빈 on 12/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public final class FABSubButton: UIView {
  private let rootFlexContainer = UIView()
  
  private let icon: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let title = MozipLabel(
    style: .heading3,
    color: MozipColor.primary700
  )
  
  public init(iconImage: UIImage, title: String) {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupViewLayout()
    self.backgroundColor = .white
    self.layer.cornerRadius = 8
    self.icon.image = iconImage
    self.title.updateTextKeepingAttributes(title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupViewLayout()
  }
}

// MARK: - Setup Layout
private extension FABSubButton {
  func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .direction(.row)
      .alignItems(.center)
      .define { flex in
        flex.addItem(icon).size(24).marginLeft(16)
        flex.addItem(title).marginLeft(8)
      }
  }
  
  func setupViewLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
    pin.size(CGSize(width: 163, height: 64))
  }
}
