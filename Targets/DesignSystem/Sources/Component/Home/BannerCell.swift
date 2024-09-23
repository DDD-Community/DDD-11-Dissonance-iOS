//
//  BannerCell.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/5/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import PinLayout
import FlexLayout
import Kingfisher

public final class BannerCell: UICollectionViewCell {
  
  private enum Metric {
    static let imageHeight: CGFloat = 154
    static let horizontalPadding: CGFloat = 20
  }
  
  // MARK: - UI
  private let bannerImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  // MARK: - Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
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
  public func setData(_ data: BannerCellData) {
    bannerImage.kf.setImage(
      with: URL(string: data.bannerImageURL),
      placeholder: UIImage.image(with: MozipColor.gray300)
    )
    bannerImage.flex.markDirty()
    setNeedsLayout()
  }
  
  private func setupViewHierarchy() {
    contentView.flex
      .direction(.row)
      .define { flex in
        flex.addItem(bannerImage)
          .width(Device.width - Metric.horizontalPadding*2)
          .height(Metric.imageHeight)
      }
  }
  
  private func setupLayout() {
    contentView.flex.layout()
  }
}
