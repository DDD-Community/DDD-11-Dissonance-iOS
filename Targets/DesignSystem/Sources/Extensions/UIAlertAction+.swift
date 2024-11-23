//
//  UIAlertAction+.swift
//  DesignSystem
//
//  Created by 한상진 on 11/15/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public extension UIAlertAction {
  
  // MARK: - Properties
  enum ActionSheetType {
    case cancel
    case postReport
    case postDelete
    case postEdit
    
    var title: String {
      switch self {
      case .cancel: "취소"
      case .postReport: "공고 신고"
      case .postDelete: "공고 삭제"
      case .postEdit: "공고 수정"
      }
    }
    
    var style: Style {
      switch self {
      case .cancel: .cancel
      case .postReport: .destructive
      case .postDelete: .destructive
      case .postEdit: .default
      }
    }
  }
  
  // MARK: - Methods
  static func makeAction(
    type: ActionSheetType,
    action: @escaping () -> Void = {}
  ) -> UIAlertAction {
    let action: UIAlertAction = .init(
      title: type.title,
      style: type.style,
      handler: { _ in action() }
    )
    
    return action
  }
}
