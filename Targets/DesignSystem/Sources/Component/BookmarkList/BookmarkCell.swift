//
//  BookmarkCell.swift
//  DesignSystem
//
//  Created by 이원빈 on 5/8/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit
import DomainLayer

import PinLayout
import FlexLayout

public final class BookmarkCell: UITableViewCell {
  
  private enum Metric {
    static let verticalSpacing: CGFloat = 9
    static let lightBackgroundColor: UIColor = MozipColor.primary50
    static let lightTextColor: UIColor = MozipColor.primary400
    static let darkBackgroundColor: UIColor = MozipColor.gray400
    static let darkTextColor: UIColor = MozipColor.white
  }
  
  // MARK: - UI
  private let remainDayTagBackground = UIView()
  private let remainDayTag = MozipLabel(style: .body4, color: MozipColor.gray500)
  private let remainDayDescription = MozipLabel(style: .body5, color: MozipColor.gray700)
  private let titleLabel = MozipLabel(style: .body1, color: MozipColor.gray700, numberOfLines: 1) // FIXME: Figma color에 750 이라 명시되어있음. 기존 DesignSystem에 매칭되는 컬러가 없어 확인 필요.
  
  // MARK: - Initializers
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func prepareForReuse() {
    super.prepareForReuse()
    
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
  // MARK: - Methods
  public func setData(_ data: BookmarkCellData) {
    setRemainDayTag(data.remainDayTag, mode: data.remainDayTag == "마감" ? .dark : .light)
    remainDayTag.flex.markDirty()
    
    remainDayDescription.updateTextKeepingAttributes(data.remainDayDescription)
    remainDayDescription.flex.markDirty()
    
    titleLabel.updateTextKeepingAttributes(data.title)
    titleLabel.flex.markDirty()

    setNeedsLayout()
  }
  
  private func setupViewHierarchy() {
    contentView.flex
      .direction(.column)
      .justifyContent(.center)
      .alignItems(.start)
      .padding(20)
      .gap(Metric.verticalSpacing)
      .define { flex in
        flex.addItem()
          .direction(.row)
          .alignItems(.center)
          .gap(12)
          .define { flex in
            flex.addItem(remainDayTagBackground)
              .backgroundColor(MozipColor.gray10)
              .cornerRadius(12)
              .define { flex in
                flex.addItem(remainDayTag)
                  .marginHorizontal(8)
                  .marginVertical(2)
              }
            flex.addItem(remainDayDescription)
            flex.addItem().grow(1)
          }
        flex.addItem(titleLabel)
      }
  }
  
  private func setupLayout() {
    contentView.flex.layout()
  }
}

// RemainDayTag 설정
private extension BookmarkCell {
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
