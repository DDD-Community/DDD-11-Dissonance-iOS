//
//  MyPageTableHeaderView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/09/01.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout

public final class MyPageTableHeaderView: UITableViewHeaderFooterView {
  
  // MARK: - Properties
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = MozipColor.gray800
    label.font = MozipFontStyle.heading1.font
    return label
  }()
  
  private let dividerView: DividerView = {
    let dividerView: DividerView = .init()
    dividerView.isHidden = true
    return dividerView
  }()
  
  // MARK: - Initializer
  public override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    setupViews()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    setupLayoutConstraints()
  }
  
  // MARK: - Methods
  public func configure(_ text: String) {
    titleLabel.text = text
  }
  
  public func setDividerView() {
    dividerView.isHidden = false
  }
}

// MARK: - Private Extenion
private extension MyPageTableHeaderView {
  func setupViews() {
    contentView.addSubview(dividerView)
    contentView.addSubview(titleLabel)
  }
  
  func setupLayoutConstraints() {
    titleLabel.pin.horizontally().marginHorizontal(20).bottom().marginBottom(20).height(20)
    dividerView.pin.horizontally().marginHorizontal(20).bottom(to: titleLabel.edge.top).marginBottom(32).height(1)
  }
}
