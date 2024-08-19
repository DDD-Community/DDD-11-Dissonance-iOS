//
//  LabelWithTextFieldView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/11.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxSwift

public final class LabelWithTextFieldView: UIView {
  
  // MARK: - Properties
  private let rootContainer: UIView = .init()
  private let label: MozipLabel = .init(style: .heading3, color: MozipColor.gray800)
  public let textField: MozipTextField = .init()
  public var textObservable: Observable<String> {
    textField.rx.text.orEmpty.asObservable()
  }
  
  // MARK: - Initializer
  public init(title: String, placeHolder: String) {
    super.init(frame: .zero)
    
    label.updateTextKeepingAttributes(title)
    textField.applyPlaceHolder(placeHolder)
    setupViews()
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
private extension LabelWithTextFieldView {
  func setupViews() {
    rootContainer.flex
      .define {
        $0.addItem(label)
        $0.addItem(textField).marginTop(12).grow(1)
      }
    
    addSubview(rootContainer)
  }
}
