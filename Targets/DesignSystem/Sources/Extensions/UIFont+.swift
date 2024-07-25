//
//  UIFont+.swift
//  DesignSystem
//
//  Created by 이원빈 on 2024/07/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public extension UIFont {
    convenience init?(pretendardStyle: PretendardFontStyle, size: CGFloat) {
        self.init(name: pretendardStyle.rawValue, size: size)
    }
}
