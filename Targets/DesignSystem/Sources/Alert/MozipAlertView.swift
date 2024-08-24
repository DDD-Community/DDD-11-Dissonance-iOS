//
//  MozipAlertView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/23.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxSwift

internal final class MozipAlertView: UIView {
  
  // MARK: - Properties
  private let rootContainer: UIView = .init()
  private let titleLabel: MozipLabel = .init(style: .heading2, color: MozipColor.gray800)
  private var messageLabel: MozipLabel? = .init(style: .body2, color: MozipColor.gray700)
  
  private let leftButton: RectangleButton = .init(
    fontStyle: .heading3,
    titleColor: MozipColor.gray700,
    backgroundColor: MozipColor.gray50,
    cornerRadius: 4
  )
  
  private let rightButton: RectangleButton = .init(
    fontStyle: .heading3,
    titleColor: MozipColor.white,
    backgroundColor: MozipColor.primary500,
    cornerRadius: 4
  )
  
  public var leftButtonTabObservable: Observable<Void> {
    leftButton.tapObservable
  }
  
  public var rightButtonTabObservable: Observable<Void> {
    rightButton.tapObservable
  }
  
  // MARK: - Initializer
  public init(title: String, message: String, leftButtonTitle: String, rightbuttonTitle: String) {
    self.leftButton.updateTitle(leftButtonTitle)
    self.rightButton.updateTitle(rightbuttonTitle)
    
    super.init(frame: .zero)
    setupViews(title: title, message: message)
    setupLayoutconstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    pin.all()
    rootContainer.pin.vCenter().horizontally(23)
    rootContainer.flex.layout()
  }
}

// MARK: - Private Extenion
private extension MozipAlertView {
  func setupViews(title: String, message: String) {
    addSubview(rootContainer)
    backgroundColor = MozipColor.dim
    
    rootContainer.backgroundColor = MozipColor.white
    rootContainer.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 0, blur: 16, spread: 0)
    
    [titleLabel, messageLabel].forEach {
      $0?.textAlignment = .center
    }
    titleLabel.updateTextKeepingAttributes(title)
    
    guard !message.isEmpty else {
      messageLabel = nil
      return
    }
    
    messageLabel?.updateTextKeepingAttributes(message)
  }
  
  func setupLayoutconstraints() {
    rootContainer.flex
      .cornerRadius(8)
      .define {
        $0.addItem(titleLabel).marginTop(27).marginHorizontal(22)
        
        if let messageLabel = self.messageLabel {
          $0.addItem(messageLabel).marginTop(16).marginHorizontal(22)
        }
        
        $0.addItem()
          .direction(.row)
          .grow(1)
          .marginTop(24)
          .height(52)
          .marginHorizontal(22)
          .marginBottom(27)
          .define {
            $0.addItem(leftButton).grow(1)
            $0.addItem().width(12)
            $0.addItem(rightButton).grow(1)
          }
      }
  }
}
