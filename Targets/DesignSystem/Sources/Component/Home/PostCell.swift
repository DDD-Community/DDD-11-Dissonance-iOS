//
//  PostCell.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/4/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import PinLayout
import FlexLayout
import Kingfisher

public final class PostCell: UICollectionViewCell {
  
  private enum Metric {
    static let verticalSpacing: CGFloat = 8
    static let imageCornerRadius: CGFloat = 8
    static let lightBackgroundColor: UIColor = MozipColor.primary50
    static let lightTextColor: UIColor = MozipColor.primary400
    static let darkBackgroundColor: UIColor = MozipColor.gray400
    static let darkTextColor: UIColor = MozipColor.white
  }
  
  // MARK: - UI
  private let thumbnailImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = Metric.imageCornerRadius
    return imageView
  }()
  
  private let titleLabel = MozipLabel(style: .body3, color: MozipColor.gray800, numberOfLines: 2)
  private let remainDayTagBackground = UIView()
  private let remainDayTag = MozipLabel(style: .body4, color: MozipColor.gray500)
  private let viewCountIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DesignSystemAsset.viewCountIcon.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  private let viewCountLabel = MozipLabel(style: .caption1, color: MozipColor.gray400, text: "349")
  
  // MARK: - Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func prepareForReuse() {
    super.prepareForReuse()
    thumbnailImage.image = nil
    titleLabel.text = nil
    remainDayTag.text = nil
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.pin.width(size.width)
    setupLayout()
    return contentView.frame.size
  }
  
  // MARK: - Methods
  public func setData(_ data: PostCellData) {
    thumbnailImage.kf.setImage(
      with: URL(string: data.imageURL),
      placeholder: UIImage.image(with: MozipColor.gray300)
    )
    thumbnailImage.flex.markDirty()
    
    titleLabel.updateTextKeepingAttributes(data.title)
    titleLabel.flex.markDirty()
    
    setRemainDayTag(data.remainTag, mode: data.remainTag == "마감" ? .dark : .light)
    remainDayTag.flex.markDirty()
    
    viewCountLabel.updateTextKeepingAttributes(String(data.viewCount))
    viewCountLabel.flex.markDirty()
    
    setNeedsLayout()
  }
  
  private func setupViewHierarchy() {
    contentView.flex
      .direction(.column)
      .alignItems(.start)
      .gap(Metric.verticalSpacing)
      .define { flex in
        flex.addItem(thumbnailImage).width(100%).aspectRatio(1)
        flex.addItem(titleLabel)
        flex.addItem()
          .width(100%)
          .direction(.row)
          .alignItems(.center)
          .define { flex in
            flex.addItem  (remainDayTagBackground)
              .backgroundColor(MozipColor.gray10)
              .cornerRadius(12)
              .define { flex in
                flex.addItem(remainDayTag)
                  .marginHorizontal(8)
                  .marginVertical(2)
              }
            flex.addItem().grow(1)
            flex.addItem(viewCountIcon).width(12).height(7.5)
            flex.addItem(viewCountLabel).marginLeft(4)
          }
      }
  }
  
  private func setupLayout() {
    contentView.flex.layout()
  }
}

// RemainDayTag 설정
private extension PostCell {
  enum Mode {
    case light
    case dark
  }
  
  func setRemainDayTag(_ text: String, mode: Mode = .light) {
    remainDayTag.updateTextKeepingAttributes(text)
    setMode(mode)
  }
  
  func setMode(_ mode: Mode) {
    let backgroundColor = (mode == .light ? Metric.lightBackgroundColor : Metric.darkBackgroundColor)
    let textColor = (mode == .light ? Metric.lightTextColor : Metric.darkTextColor)
    
    remainDayTagBackground.backgroundColor = backgroundColor
    remainDayTag.updateColorKeepingAttributed(textColor)
  }
}
