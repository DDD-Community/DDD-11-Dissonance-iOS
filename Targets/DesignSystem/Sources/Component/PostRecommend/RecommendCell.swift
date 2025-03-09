//
//  RecommendCell.swift
//  PresentationLayer
//
//  Created by 이원빈 on 2/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import RxSwift
import PinLayout
import FlexLayout
import Kingfisher

final class RecommendCell: UICollectionViewCell {
  
  // MARK: Properties
  public var disposeBag = DisposeBag()
  
  public var editButtonTapObservable: Observable<UIGestureRecognizer> {
    editButton.rxGesture.tap.asObservable()
  }
  
  public var thumbnailImageTapObservable: Observable<UIGestureRecognizer> {
    thumbnailImageView.rxGesture.tap.asObservable()
  }
  
  // MARK: UI
  private let rootFlexContainer = UIView()
  private let titleLabel = MozipLabel(style: .heading3, color: MozipColor.gray800)
  private let subTitleLabel = MozipLabel(style: .body4, color: MozipColor.gray500)

  private let editButton: MozipLabel = {
    let label = MozipLabel(style: .body2, color: MozipColor.red, text: "공고 변경")
    label.isUserInteractionEnabled = true
    return label
  }()
  
  private let thumbnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  // MARK: Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.updateTextKeepingAttributes("")
    subTitleLabel.updateTextKeepingAttributes("")
    disposeBag = DisposeBag()
  }
  
  public func setData(_ data: RecommendCellData) {
    titleLabel.text = data.title
    subTitleLabel.text = data.subTitle
    
    if let imageData = data.imageData {
      thumbnailImageView.image = UIImage(data: imageData)
    } else {
      thumbnailImageView.kf.setImage(with: URL(string: data.thumbnailURL))
    }
    
    if data.isUploadAvailable {
      rootFlexContainer.layer.borderColor = MozipColor.primary500.cgColor
      rootFlexContainer.layer.borderWidth = 4
    } else {
      rootFlexContainer.layer.borderColor = nil
      rootFlexContainer.layer.borderWidth = 0
    }
    
    rootFlexContainer.flex.markDirty()
    rootFlexContainer.flex.layout()
  }
}

// MARK: - Setup Layout
private extension RecommendCell {
  func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .direction(.column)
      .define { flex in
        flex.addItem()
          .direction(.row)
          .define { flex in
            flex.addItem(titleLabel)
            flex.addItem().grow(1)
            flex.addItem(editButton)
          }
        flex.addItem(subTitleLabel).marginTop(12)
        
        flex.addItem(thumbnailImageView)
          .marginTop(4)
          .width(100%)
          .aspectRatio(2)
      }
  }
  
  func setupLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout(mode: .fitContainer)
  }
}
