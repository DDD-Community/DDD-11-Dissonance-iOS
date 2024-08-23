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

public final class PostCell: UICollectionViewCell {
  
  private enum Metric {
    static let verticalSpacing: CGFloat = 8
    static let width: CGFloat = 148
    static let imageHeight: CGFloat = 148
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
//  public override func prepareForReuse() {
  // TODO: 데이터 연결 후 작업
//    super.prepareForReuse()
//    postImage.image = nil
//    titleLabel.text = nil
//  }
  
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
    thumbnailImage.image = UIImage.image(with: MozipColor.gray300)/*data.imageURL*/ // FIXME: 이미지 처리방법 논의 필요.
    thumbnailImage.flex.markDirty()
    
    titleLabel.updateTextKeepingAttributes(data.title)
    titleLabel.flex.markDirty()
    
    remainDayTag.setText(data.remainTag)
    remainDayTag.flex.markDirty()
    
    setNeedsLayout()
  }
  
  private func setupViewHierarchy() {
    contentView.flex
      .direction(.column)
      .alignItems(.start)
      .gap(Metric.verticalSpacing)
      .width(Metric.width)
      .define { flex in
        flex.addItem(thumbnailImage).width(Metric.width).height(Metric.imageHeight)
        flex.addItem(titleLabel)
        flex.addItem(remainDayTag)
      }
  }
  
  private func setupLayout() {
    contentView.flex.layout()
  }
}
