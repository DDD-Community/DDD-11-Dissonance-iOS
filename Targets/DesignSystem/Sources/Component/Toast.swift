//
//  Toast.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/3/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

public final class Toast: UIView {
  
  private enum Metric {
    static let height: CGFloat = 56
    static let horizontalPadding: CGFloat = 20
    static let bottomMargin: CGFloat = 24
    static let cornerRadius: CGFloat = 8
    static let animationDuration: CGFloat = 0.5
    static let zero: CGFloat = 0
    static let one: CGFloat = 1
  }
  
  // MARK: - UI
  private let messageLabel = MozipLabel(style: .body1, color: MozipColor.white)
  private let rootFlexContainer = UIView()
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupInitialSetting()
    setupGestureRecognizer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayer()
  }
  
  // MARK: - Methods
  public func setMessage(_ message: String) {
    messageLabel.updateTextKeepingAttributes(message)
  }
  
  public func showIn(view: UIView, duration: CGFloat, _ completion: (() -> Void)?) {
    view.addSubview(self)
    self.pin.horizontally(Metric.horizontalPadding).height(Metric.height).bottom(-Metric.height)
    self.rootFlexContainer.flex.layout()
    
    UIView.animate(withDuration: Metric.animationDuration, animations: {
      self.pin.bottom(view.pin.safeArea.bottom).marginBottom(Metric.bottomMargin)
      self.alpha = Metric.one
    }, completion: { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        self.hide()
        completion?()
      }
    })
  }
  
  private func hide() {
    UIView.animate(withDuration: Metric.animationDuration, animations: {
      self.pin.bottom(-Metric.height)
      self.alpha = Metric.zero
    }, completion: { _ in
      self.removeFromSuperview()
    })
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex.direction(.row).justifyContent(.center).define { flex in
      flex.addItem(messageLabel)
    }
  }
  
  private func setupLayer() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
  
  private func setupInitialSetting() {
    self.backgroundColor = MozipColor.gray800
    self.layer.cornerRadius = Metric.cornerRadius
    self.alpha = Metric.zero
  }
  
  private func setupGestureRecognizer() {
    let swipeGestureRecognizer = UISwipeGestureRecognizer(
      target: self,
      action: #selector(toastSwipeDown)
    )
    swipeGestureRecognizer.direction = .down
    self.addGestureRecognizer(swipeGestureRecognizer)
  }
  
  @objc
  private func toastSwipeDown() {
    self.hide()
  }
}
