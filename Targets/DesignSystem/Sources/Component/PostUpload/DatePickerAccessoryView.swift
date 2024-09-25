//
//  DatePickerAccessoryView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/16.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxSwift

public final class DatePickerAccessoryView: UIStackView {
  
  // MARK: - Properties
  private let cancelButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(MozipColor.gray800, for: .normal)
    button.titleLabel?.font = MozipFontStyle.heading1.font
    return button
  }()
  
  private let completionButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("완료", for: .normal)
    button.setTitleColor(MozipColor.gray800, for: .normal)
    button.titleLabel?.font = MozipFontStyle.heading1.font
    return button
  }()
  
  private let dividerView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: 1).isActive = true
    view.heightAnchor.constraint(equalToConstant: 44).isActive = true
    return view
  }()
  
  public var cancelButtonTapObservable: Observable<Void> {
    cancelButton.rx.tap.asObservable()
  }
  
  public var completionButtonTapObservable: Observable<Void> {
    completionButton.rx.tap.asObservable()
  }
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    
    setupView()
  }
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Extenion
private extension DatePickerAccessoryView {
  func setupView() {
    distribution = .fillProportionally
    alignment = .center
    spacing = 1
    backgroundColor = MozipColor.gray50
    frame.size.height = 44
    addArrangedSubview(cancelButton)
    addArrangedSubview(dividerView)
    addArrangedSubview(completionButton)
  }
}
