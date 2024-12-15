//
//  FABButton.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/11/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import UIKit

import PinLayout
import FlexLayout
import RxSwift
import RxRelay

public final class FABButton: UIView {
  
  private enum Metric {
    static let cornerRadius: CGFloat = 36
  }
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  public private(set) var isExpanded: BehaviorRelay<Bool> = .init(value: false)
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  
  private let plusIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = DesignSystemAsset.plus.image.withTintColor(.white, renderingMode: .alwaysOriginal)
    return imageView
  }()
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    bindButton()
    bindState()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayer()
    setupShadow()
  }
  
  // MARK: - Methods
  private func bindButton() {
    self.rxGesture.tap
      .subscribe(with: self) { owner, _ in
        owner.isExpanded.accept(!owner.isExpanded.value)
      }
      .disposed(by: disposeBag)
  }
  
  private func bindState() {
    isExpanded
      .asDriver()
      .drive(with: self) { owner, bool in
        owner.rootFlexContainer.flex.backgroundColor(bool ? MozipColor.white : MozipColor.primary500)
        owner.plusIcon.image = bool ?
        DesignSystemAsset.xmark.image.withTintColor(MozipColor.primary500, renderingMode: .alwaysOriginal) :
        DesignSystemAsset.plus.image.withTintColor(MozipColor.white, renderingMode: .alwaysOriginal)

        owner.rootFlexContainer.flex.layout()
      }
      .disposed(by: disposeBag)
  }
  
  // MARK: - Layout
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .justifyContent(.center)
      .alignItems(.center)
      .cornerRadius(Metric.cornerRadius)
      .backgroundColor(MozipColor.primary500)
      .define { flex in
        flex.addItem(plusIcon)
      }
  }
  
  private func setupLayer() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
    pin.size(CGSize(width: 72, height: 72))
  }
  
  private func setupShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 4
  }
}
