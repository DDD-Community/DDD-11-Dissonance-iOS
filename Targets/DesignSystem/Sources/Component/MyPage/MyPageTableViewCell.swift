//
//  MyPageTableViewCell.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/30.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout

public final class MyPageTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  public enum SocialType {
    case kakao, apple
  }
  
  private let titleLabel: MozipLabel = .init(style: .body2, color: MozipColor.gray500)
  private let versionLabel: MozipLabel = .init(style: .body2, color: MozipColor.gray300)
  
  private let socialTypeImageView: UIImageView = {
    let imageView: UIImageView = .init()
    imageView.contentMode = .scaleAspectFit
    imageView.isHidden = true
    return imageView
  }()
  
  // MARK: - Initializer
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  public override func prepareForReuse() {
    super.prepareForReuse()

    titleLabel.updateTextKeepingAttributes(" ")
    versionLabel.updateTextKeepingAttributes(" ")
    socialTypeImageView.image = nil
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    setupLayoutconstraints()
  }
  
  // MARK: - Methods
  public func configure(title: String) {
    titleLabel.updateTextKeepingAttributes(title)
  }
  
  public func configure(socialType: SocialType) {
    titleLabel.updateTextKeepingAttributes("연결된 계정")
    socialTypeImageView.image = socialType == .kakao ? DesignSystemAsset.kakaoAccountIcon.image : DesignSystemAsset.appleAccountIcon.image
    socialTypeImageView.isHidden = false
  }
  
  public func configureVersion() {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String,
          let build = dictionary["CFBundleVersion"] as? String else {
      return
    }
    
    titleLabel.updateTextKeepingAttributes("버전 정보")
    versionLabel.updateTextKeepingAttributes("\(version).\(build)")
    versionLabel.isHidden = false
  }
}

// MARK: - Private Extenion
private extension MyPageTableViewCell {
  func setupViews() {
    backgroundColor = .white
    selectionStyle = .none
    versionLabel.isHidden = true
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(socialTypeImageView)
    contentView.addSubview(versionLabel)
  }
  
  func setupLayoutconstraints() {
    contentView.pin.horizontally().marginHorizontal(20)
    titleLabel.pin.vCenter().left().height(22).sizeToFit(.height)
    socialTypeImageView.pin.vCenter().right().height(40).sizeToFit(.height)
    versionLabel.pin.vCenter().right(12).height(22).sizeToFit(.height)
  }
}
