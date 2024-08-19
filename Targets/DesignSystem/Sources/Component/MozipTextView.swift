//
//  MozipTextView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/16.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift

public final class MozipTextView: UITextView {
  
  // MARK: - Properties
  private var placeHolder: String = .init()
  private let disposeBag: DisposeBag = .init()
  
  // MARK: - Initializer
  public init(placeHolder: String = .init()) {
    super.init(frame: .zero, textContainer: nil)
    
    applyPlaceHolder(placeHolder)
    setupView()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  internal func applyPlaceHolder(_ placeHolder: String) {
    self.placeHolder = placeHolder
    text = placeHolder
  }
}

// MARK: - Private Extenion
private extension MozipTextView {
  func setupView() {
    textColor = MozipColor.gray200
    font = MozipFontStyle.body6.font
    textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    layer.borderWidth = 1
    layer.borderColor = MozipColor.gray200.cgColor
    layer.cornerRadius = 8
    autocorrectionType = .no
    spellCheckingType = .no
  }
  
  func bind() {
    rx.didBeginEditing
      .withLatestFrom(rx.text.orEmpty)
      .withUnretained(self)
      .map { owner, text in
        text == owner.placeHolder && owner.textColor == MozipColor.gray200
      }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, isDefault in
        owner.text = isDefault ? .init() : owner.text
        owner.layer.borderColor = MozipColor.gray700.cgColor
        owner.textColor = MozipColor.gray700
      })
      .disposed(by: disposeBag)
    
    rx.didEndEditing
      .withLatestFrom(rx.text.orEmpty)
      .filter { $0.isEmpty }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.text = owner.placeHolder
        owner.layer.borderColor = MozipColor.gray200.cgColor
        owner.textColor = MozipColor.gray200
      })
      .disposed(by: disposeBag)
  }
}
