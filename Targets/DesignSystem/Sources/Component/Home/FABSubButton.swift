//
//  FABSubButton.swift
//  DesignSystem
//
//  Created by 이원빈 on 12/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift

public final class FABSubButton: UIView {
  // MARK: Properties
  public var registPostButtonObservable: Observable<Void> {
    registPostButton.rx.tap.asObservable()
  }
  
  public var recommendPostButtonObservable: Observable<Void> {
    recommendPostButton.rx.tap.asObservable()
  }
  
  // MARK: UI
  private let rootFlexContainer = UIView()
  
  private let registPostButton = UIButton()
  
  private let registPostIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = DesignSystemAsset.registerPost.image
    return imageView
  }()
  
  private let registPostTitle = MozipLabel(
    style: .heading3,
    color: MozipColor.primary700,
    text: "공고 등록"
  )
  
  private let recommendPostButton = UIButton()
  
  private let recommendPostIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = DesignSystemAsset.pin2.image
    return imageView
  }()
  
  private let recommendPostTitle = MozipLabel(
    style: .heading3,
    color: MozipColor.primary700,
    text: "추천 공고 관리"
  )
  
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupViewLayout()
    self.backgroundColor = .white
    self.layer.cornerRadius = 8
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
      .direction(.column)
      .alignItems(.start)
      .define { flex in
        flex.addItem(registPostButton)
          .direction(.row)
          .alignItems(.center)
          .marginTop(20)
          .define { flex in
            flex.addItem(registPostIcon).size(24).marginLeft(16)
            flex.addItem(registPostTitle).marginLeft(8)
          }
        
        flex.addItem(recommendPostButton)
          .direction(.row)
          .alignItems(.center)
          .marginTop(20)
          .define { flex in
            flex.addItem(recommendPostIcon).size(24).marginLeft(16)
            flex.addItem(recommendPostTitle).marginLeft(8)
          }
      }
  }
  
  func setupViewLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
    pin.size(CGSize(width: 163, height: 108))
  }
}
