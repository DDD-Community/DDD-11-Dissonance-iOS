//
//  NumberCountView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/15.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

public final class NumberCountView: UIView {
  
  // MARK: - Properties
  private let rootContainer: UIView = .init()
  private let numberLabel: MozipLabel = .init(style: .body1, color: MozipColor.gray200, text: "0")
  
  private let minusButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("-", for: .normal)
    button.titleLabel?.font = MozipFontStyle.body1.font
    button.setTitleColor(MozipColor.gray200, for: .normal)
    return button
  }()
  
  private let plusButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("+", for: .normal)
    button.titleLabel?.font = MozipFontStyle.body1.font
    button.setTitleColor(MozipColor.gray200, for: .normal)
    return button
  }()
  
  public let numberCountSubject: BehaviorSubject<Int> = .init(value: 0)
  private let disposeBag: DisposeBag = .init()
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    
    setupViews()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  // MARK: - Methods
  internal func updateColors(_ isEnable: Bool) {
    layer.borderColor = isEnable ? MozipColor.gray700.cgColor : MozipColor.gray200.cgColor
    numberLabel.updateColorKeepingAttributed(isEnable ? MozipColor.gray700: MozipColor.gray200)
    minusButton.setTitleColor(isEnable ? MozipColor.gray700 : MozipColor.gray200, for: .normal)
    plusButton.setTitleColor(isEnable ? MozipColor.gray700 : MozipColor.gray200, for: .normal)
  }
}

// MARK: - Private Extenion
private extension NumberCountView {
  func setupViews() {
    layer.borderWidth = 1
    layer.borderColor = MozipColor.gray200.cgColor
    layer.cornerRadius = 8
    
    addSubview(rootContainer)
    
    rootContainer.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .define {
        $0.addItem(minusButton).paddingLeft(5)
        $0.addItem(numberLabel)
        $0.addItem(plusButton).paddingRight(5)
      }
  }
  
  func bind() {
    minusButton.rx.tap
      .withLatestFrom(numberCountSubject)
      .map { $0 - 1 }
      .filter { $0 >= 0 }
      .bind(with: self, onNext: { owner, count in
        owner.numberCountSubject.onNext(count)
        owner.numberLabel.updateTextKeepingAttributes(String(count))
      })
      .disposed(by: disposeBag)
    
    plusButton.rx.tap
      .withLatestFrom(numberCountSubject)
      .map { $0 + 1 }
      .bind(with: self, onNext: { owner, count in
        owner.numberCountSubject.onNext(count)
        owner.numberLabel.updateTextKeepingAttributes(String(count))
      })
      .disposed(by: disposeBag)
  }
}
