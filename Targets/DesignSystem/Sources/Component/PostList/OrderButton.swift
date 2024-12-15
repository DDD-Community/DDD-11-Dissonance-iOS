//
//  OrderButton.swift
//  DesignSystem
//
//  Created by 이원빈 on 12/8/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import RxCocoa
import RxSwift

public final class OrderButton: UIView {
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  private let dropDownLabel = MozipLabel(style: .body5, color: MozipColor.gray500, text: "최신순")
  private let dropDownIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = DesignSystemAsset.dropDownIcon.image
    return imageView
  }()
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupViewLayout()
    setupInitialState()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupViewLayout()
  }
  
  // MARK: - Methods
  public func setTitle(text: String) {
    dropDownLabel.updateTextKeepingAttributes(text)
  }
  
  private func setupViewHierarchy() {
    self.addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(dropDownLabel)
        flex.addItem(dropDownIcon).size(20)
      }
  }
  
  private func setupViewLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
    pin.size(.init(width: 57, height: 20))
  }
  
  private func setupInitialState() {
    
  }
}
