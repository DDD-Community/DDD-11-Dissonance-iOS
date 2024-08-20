//
//  PostHeader.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

public final class PostHeader: UICollectionReusableView {
  
  private enum Metric {
    static let height: CGFloat = 22
    static let buttonSpacing: CGFloat = 4
    static let iconSize: CGFloat = 16
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  private let sectionTitle = MozipLabel(style: .heading1, color: MozipColor.gray800)
  
  public let showMoreButton = UIButton(type: .custom)
  private let buttonLabel = MozipLabel(style: .body2, color: MozipColor.gray700, text: "더보기")
  private let buttonImageView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFit
    imgView.image = DesignSystemAsset.chevronRight.image
    imgView.tintColor = MozipColor.gray700
    return imgView
  }()
  
  // MARK: - Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
//  public override func prepareForReuse() {
//    super.prepareForReuse()
//  }
  
  // MARK: - Methods
  public func setTitle(_ text: String) {
    sectionTitle.updateTextKeepingAttributes(text)
    sectionTitle.flex.markDirty()
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    
    rootFlexContainer.flex.direction(.row).height(Metric.height).define { flex in
      flex.addItem(sectionTitle)
      flex.addItem().grow(1)
      flex.addItem(showMoreButton).direction(.row).alignItems(.center).justifyContent(.end).define { flex in
        flex.addItem(buttonLabel).marginRight(Metric.buttonSpacing)
        flex.addItem(buttonImageView).size(Metric.iconSize)
      }
    }
  }
  
  private func setupLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
}
