//
//  MozipLabel.swift
//  DesignSystem
//
//  Created by 이원빈 on 2024/07/26.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public final class MozipLabel: UILabel {
    
    public init(style: MozipLabelStyle, text: String = "") {
        super.init(frame: .zero)
        self.numberOfLines = 0
        self.font = style.labelSettings.font
        self.textColor = style.labelSettings.color
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum MozipLabelStyle {
    case header_HeaderTitle
    case toast_ToastMessage
    case bottom_BTNMessage
    case fabButton_FABText
    case tag_TagLabel
    case popup_PopupTitle
    case popup_PopupMessage
    case popup_BTNDeny
    case popup_BTNApprove
    case postList_PostDetailText
    
    var labelSettings: MozipLabelSetting {
        switch self {
        case .header_HeaderTitle:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 18),
                color: .mozipColor.gray900,
                lineHeightMultiplier: 1
            )
        case .toast_ToastMessage:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                color: .mozipColor.white,
                lineHeightMultiplier: 1
            )
        case .bottom_BTNMessage:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 20),
                color: .mozipColor.white,
                lineHeightMultiplier: 1
            )
        case .fabButton_FABText:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.bold.font(size: 14),
                color: .mozipColor.white,
                lineHeightMultiplier: 1
            )
        case .tag_TagLabel:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                color: .mozipColor.gray500,
                lineHeightMultiplier: 1
            )
        case .popup_PopupTitle:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 18),
                color: .mozipColor.gray800,
                lineHeightMultiplier: 1
            )
        case .popup_PopupMessage:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.regular.font(size: 16),
                color: .mozipColor.gray700,
                lineHeightMultiplier: 1.4
            )
        case .popup_BTNDeny:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 16),
                color: .mozipColor.gray700,
                lineHeightMultiplier: 1
            )
        case .popup_BTNApprove:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 16),
                color: .mozipColor.white,
                lineHeightMultiplier: 1
            )
        case .postList_PostDetailText:
            return MozipLabelSetting(
                font: DesignSystemFontFamily.Pretendard.regular.font(size: 16),
                color: .mozipColor.gray800,
                lineHeightMultiplier: 1.5
            )
        }
    }
}

public struct MozipLabelSetting {
    let font: UIFont
    let color: UIColor
    let lineHeightMultiplier: CGFloat
}
