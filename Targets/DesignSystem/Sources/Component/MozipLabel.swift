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
    
    var labelSettings: (font: UIFont?, color: UIColor) {
        switch self {
        case .header_HeaderTitle: return (DesignSystemFontFamily.Pretendard.semiBold.font(size: 18), .mozipColor.gray900)
        case .toast_ToastMessage: return (DesignSystemFontFamily.Pretendard.medium.font(size: 16), .mozipColor.gray900)
        case .bottom_BTNMessage: return (DesignSystemFontFamily.Pretendard.semiBold.font(size: 20), .mozipColor.gray900)
        case .fabButton_FABText: return (DesignSystemFontFamily.Pretendard.bold.font(size: 14), .mozipColor.gray900)
        case .tag_TagLabel: return (DesignSystemFontFamily.Pretendard.medium.font(size: 14), .mozipColor.gray900)
        case .popup_PopupTitle: return (DesignSystemFontFamily.Pretendard.semiBold.font(size: 18), .mozipColor.gray900)
        case .popup_PopupMessage: return (DesignSystemFontFamily.Pretendard.regular.font(size: 16), .mozipColor.gray900)
        case .popup_BTNDeny: return (DesignSystemFontFamily.Pretendard.semiBold.font(size: 16), .mozipColor.gray900)
        case .popup_BTNApprove: return (DesignSystemFontFamily.Pretendard.semiBold.font(size: 16), .mozipColor.gray900)
        case .postList_PostDetailText: return (DesignSystemFontFamily.Pretendard.regular.font(size: 16), .mozipColor.gray900)
        }
    }
}
