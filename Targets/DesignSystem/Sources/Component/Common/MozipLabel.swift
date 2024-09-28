//
//  MozipLabel.swift
//  DesignSystem
//
//  Created by 이원빈 on 2024/07/26.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public final class MozipLabel: UILabel {
  
  // MARK: - Initializer
  public init(style: MozipFontStyle, color: UIColor, text: String = " ", numberOfLines: Int = 0) {
    super.init(frame: .zero)
    self.numberOfLines = numberOfLines
    
    setTextWithLineHeight(style: style, textColor: color, text: text)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  func updateTextKeepingAttributes(_ newText: String) {
    guard let currentAttributedText = self.attributedText else {
      self.text = newText
      return
    }
    
    let newAttributedText = NSMutableAttributedString(attributedString: currentAttributedText)
    newAttributedText.mutableString.setString(newText)
    self.attributedText = newAttributedText
  }
  
  func updateColorKeepingAttributed(_ color: UIColor) {
    guard let currentAttributedText = self.attributedText else {
      self.textColor = color
      return
    }
    
    let newAttributedText = NSMutableAttributedString(attributedString: currentAttributedText)
    newAttributedText.addAttribute(
      .foregroundColor,
      value: color,
      range: NSRange(location: 0, length: newAttributedText.length)
    )
    self.attributedText = newAttributedText
  }
}

// MARK: - Private Extenion
private extension MozipLabel {
  func setTextWithLineHeight(style: MozipFontStyle, textColor: UIColor, text: String) {
    let font = style.font
    let lineHeight = font.pointSize * (style.lineHeightMultiplier)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .left
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.maximumLineHeight = lineHeight
    
    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: paragraphStyle,
      .baselineOffset: (lineHeight - font.lineHeight) / 4,
      .font: font,
      .foregroundColor: textColor
    ]
    
    let attributedText = NSAttributedString(string: text, attributes: attributes)
    self.attributedText = attributedText
  }
}
