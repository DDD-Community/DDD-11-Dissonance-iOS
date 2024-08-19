//
//  MozipTextField.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/11.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift

public final class MozipTextField: UITextField {
  
  // MARK: - Properties
  private let disposeBag: DisposeBag = .init()
  
  // MARK: - Initializer
  public init(placeHolder: String = .init()) {
    super.init(frame: .zero)
    
    applyPlaceHolder(placeHolder)
    setupView()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  internal func applyPlaceHolder(_ placeHolder: String) {
    attributedPlaceholder = NSAttributedString(
      string: placeHolder,
      attributes: [
        NSAttributedString.Key.foregroundColor : MozipColor.gray200
      ]
    )
  }
}

// MARK: - Private Extenion
private extension MozipTextField {
  func setupView() {
    textColor = MozipColor.gray700
    layer.borderWidth = 1
    layer.borderColor = MozipColor.gray200.cgColor
    layer.cornerRadius = 8
    leftViewMode = .always
    rightViewMode = .always
    leftView = .init(frame: .init(x: 0, y: 0, width: 16, height: 1))
    rightView = .init(frame: .init(x: 0, y: 0, width: 16, height: 1))
    autocorrectionType = .no
    spellCheckingType = .no
  }
  
  func bind() {
    rx.controlEvent(.editingDidBegin)
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.layer.borderColor = MozipColor.gray700.cgColor
      })
      .disposed(by: disposeBag)
    
    rx.controlEvent(.editingDidEnd)
      .withLatestFrom(rx.text.orEmpty)
      .map { $0.isEmpty }
      .asSignal(onErrorJustReturn: true)
      .emit(with: self, onNext: { owner, isEmpty in
        owner.layer.borderColor = isEmpty ? MozipColor.gray200.cgColor : MozipColor.gray700.cgColor
      })
      .disposed(by: disposeBag)
  }
}
