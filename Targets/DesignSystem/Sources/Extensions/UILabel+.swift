//
//  UILabel+.swift
//  DesignSystem
//
//  Created by 이원빈 on 2024/07/29.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public extension UILabel {
  
  func setMozipLabel(style: MozipLabelStyle, color: UIColor, text: String) {
    
    setTextWithLineHeight(
      text,
      lineHeight: style.labelSettings.font.lineHeight * (style.labelSettings.lineHeightMultiplier),
      font: style.labelSettings.font,
      textColor: color
    )
  }
  
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
  
  private func setTextWithLineHeight(_ text: String, lineHeight: CGFloat, font: UIFont?, textColor: UIColor) {
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.maximumLineHeight = lineHeight
    
    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: paragraphStyle,
      .font: font ?? UIFont.systemFont(ofSize: 16),
      .foregroundColor: textColor
    ]
    
    let attributedText = NSAttributedString(string: text, attributes: attributes)
    self.attributedText = attributedText
  }
}