//
//  SortButton.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/22/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public final class SortButton: UIButton {
  
  // MARK: - UI
  private let nameLabel = MozipLabel(style: .body5, color: MozipColor.gray600)
  
  // MARK: - Initializer
  public init(title: String) {
    super.init(frame: .zero)
    nameLabel.updateTextKeepingAttributes(title)
    setupViewHierarchy()
    setupConstraints()
    setupInitialState()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  public func setHighlight(_ bool: Bool) {
    nameLabel.updateColorKeepingAttributed(bool ? MozipColor.primary500 : MozipColor.gray600)
    self.layer.borderWidth = bool ? 1 : 0
    self.layer.borderColor = bool ? MozipColor.primary500.cgColor : UIColor.clear.cgColor
  }
  
  private func setupViewHierarchy() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(nameLabel)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
  
  private func setupInitialState() {
    self.backgroundColor = MozipColor.gray10
    self.layer.cornerRadius = 4
  }
}
