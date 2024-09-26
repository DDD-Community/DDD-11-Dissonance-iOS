//
//  TextFieldWithCountView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/15.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import RxSwift

public final class TextFieldWithCountView: UIView {
  
  // MARK: - Properties
  private let rootContainer: UIView = .init()
  private let textField: MozipTextField = .init(placeHolder: "모집 대상을 입력해주세요.")
  private let numberCountView: NumberCountView = .init()
  public let valueSubject: BehaviorSubject<(job: String, count: Int)> = .init(value: (job: .init(), count: .init()))
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
}

// MARK: - Private Extenion
private extension TextFieldWithCountView {
  func setupViews() {
    addSubview(rootContainer)
    
    rootContainer.flex
      .direction(.row)
      .justifyContent(.end)
      .define {
        $0.addItem(textField).marginRight(16).grow(1)
        $0.addItem(numberCountView).width(33%)
      }
  }
  
  func bind() {
    Observable.combineLatest(textField.rx.text.orEmpty, numberCountView.numberCountSubject)
      .map { $0 }
      .bind(to: valueSubject)
      .disposed(by: disposeBag)
    
    textField.rx.controlEvent(.editingDidBegin)
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.numberCountView.updateColors(true)
      })
      .disposed(by: disposeBag)
    
    textField.rx.controlEvent(.editingDidEnd)
      .withLatestFrom(textField.rx.text.orEmpty)
      .map { $0.isEmpty }
      .asSignal(onErrorJustReturn: true)
      .emit(with: self, onNext: { owner, isEmpty in
        owner.numberCountView.updateColors(!isEmpty)
      })
      .disposed(by: disposeBag)
  }
}
