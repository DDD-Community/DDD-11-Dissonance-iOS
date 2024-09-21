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
  }
  
  // MARK: - UI
  private let thumbnailImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = Metric.imageCornerRadius
    return imageView
  }()
  
  private let titleLabel = MozipLabel(style: .body3, color: MozipColor.gray800)
  private let remainDayTag = RemainDayTag()
  
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
    
    remainDayTag.setText(data.remainTag, mode: data.remainTag == "마감" ? .dark : .light) // FIXME: 추후 수정
    remainDayTag.flex.markDirty()
    
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
        flex.addItem(remainDayTag)
      }
  }
  
  private func setupLayout() {
    contentView.flex.layout()
  }
}
