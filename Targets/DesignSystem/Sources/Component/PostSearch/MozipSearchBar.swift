//
//  MozipSearchBar.swift
//  DesignSystem
//
//  Created by 이원빈 on 12/21/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public final class MozipSearchBar: UIView {
  
  private enum Metric {
    static let horizontalPadding: CGFloat = 20
    static let buttonSize: CGFloat = 24
    static let statusBarHeight = Device.statusBarFrame.height
  }
  
  public var backButtonTapObservable: Observable<Void> {
    backButton.rx.tap.asObservable()
  }
  
  public var searchTextObservable: Observable<String?> {
    searchField.rx.text.asObservable()
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(DesignSystemAsset.chevronLeft.image, for: .normal)
    return button
  }()
  
  private let searchField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "찾고 싶은 공고를 입력하세요"
    textField.setLeftPadding(16)
    textField.backgroundColor = MozipColor.gray50
    textField.font = MozipFontStyle.body4.font
    textField.layer.cornerRadius = 8
    return textField
  }()
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func layoutSubviews() {
    super.layoutSubviews()
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
  
  // MARK: - Methods
  
  private func setupViews() {
    addSubview(rootFlexContainer)
    
    rootFlexContainer.flex
      .direction(.row)
      .marginHorizontal(Metric.horizontalPadding)
      .marginTop(Metric.statusBarHeight)
      .alignItems(.center)
      .define{
        $0.addItem(backButton).size(Metric.buttonSize).marginRight(16)
        $0.addItem(searchField).height(44).grow(1)
      }
  }
}
