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
import RxSwift

public final class PostHeader: UICollectionReusableView {
  
  private enum Metric {
    static let buttonSpacing: CGFloat = 4
    static let iconSize: CGFloat = 16
    static let horizontalMargin: CGFloat = 20
  }
  
  public var tapObservable: Observable<Void> {
    showMoreButton.rx.tap.asObservable()
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  private let sectionTitle = MozipLabel(style: .heading1, color: MozipColor.gray800)
  private let sectionSummary = MozipLabel(style: .body5, color: MozipColor.gray500)
  private let showMoreButton = UIButton(type: .custom)
  private let buttonLabel = MozipLabel(style: .body4, color: MozipColor.gray700, text: "더보기")
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
  // TODO: 추후 구현
//    super.prepareForReuse()
//  }
  
  // MARK: - Methods
  public func setData(title: String, summary: String) {
    sectionTitle.updateTextKeepingAttributes(title)
    sectionTitle.flex.markDirty()
    
    sectionSummary.updateTextKeepingAttributes(summary)
    sectionSummary.flex.markDirty()
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    
    rootFlexContainer.flex
      .height(92)
      .define { flex in
        flex.addDivider(height: 8, color: MozipColor.gray10)
        
        flex.addItem()
          .direction(.row)
          .height(22)
          .marginTop(36)
          .define { flex in
            flex.addItem(sectionTitle).marginLeft(20)
            flex.addItem().grow(1)
            
            flex.addItem(showMoreButton)
              .direction(.row)
              .alignItems(.center)
              .justifyContent(.end)
              .marginRight(20)
              .define { flex in
                flex.addItem(buttonLabel).marginRight(Metric.buttonSpacing)
                flex.addItem(buttonImageView).size(Metric.iconSize)
              }
          }
        
        flex.addItem(sectionSummary).height(20).marginTop(8).horizontally(20)
      }
  }
  
  private func setupLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
}
