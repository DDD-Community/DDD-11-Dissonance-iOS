//
//  UIFont+MozipFont.swift
//  DesignSystem
//
//  Created by 이원빈 on 2024/07/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

extension UIFont {
    public static let mozipFont = MozipFont()
}

public struct MozipFont {
    public var body = UIFont(pretendardStyle: .black, size: 12)
    public var title = UIFont(pretendardStyle: .thin, size: 15)
    public var headline = UIFont(pretendardStyle: .black, size: 14)
}

public enum PretendardFontStyle: String {
    case black = "Pretendard-Black"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case semiBold = "Pretendard-SemiBold"
    case thin = "Pretendard-Thin"
}
