//
//  Alertable.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DesignSystem
import UIKit

public protocol Alertable {}

public enum AlertType {
  case report
  case logout
  case deleteAccount
  
  var title: String {
    switch self {
    case .report: "해당 공고를 신고하시겠습니까?"
    case .logout: "로그아웃 하시겠습니까?"
    case .deleteAccount: "정말 탈퇴하시겠습니까?"
    }
  }
  
  var message: String {
    switch self {
    case .report: "신고 접수 후 이후 조치까지\n영업일 기준 최소 3일 이상 소요될 수 있습니다."
    case .logout: ""
    case .deleteAccount: "탈퇴하기 버튼 선택 시,\n계정은 삭제되며 복구할 수 없습니다."
    }
  }
  
  var leftButtonTitle: String {
    switch self {
    default: "취소하기"
    }
  }
  
  var rightButtonTitle: String {
    switch self {
    case .report: "신고하기"
    case .logout: "로그아웃"
    case .deleteAccount: "탈퇴하기"
    }
  }
}

public extension Alertable where Self: UIViewController {
  func presentAlert(
    type: AlertType,
    leftButtonAction: @escaping () -> Void = {},
    rightButtonAction: @escaping () -> Void
  ) {
    let alertController: MozipAlertController = .init(
      title: type.title,
      message: type.message,
      leftButtonTitle: type.leftButtonTitle,
      rightbuttonTitle: type.rightButtonTitle
    )
    alertController.modalPresentationStyle = .overCurrentContext
    alertController.modalTransitionStyle = .crossDissolve
    alertController.leftButtonAction = leftButtonAction
    alertController.rightButtonAction = rightButtonAction
    present(alertController, animated: true)
  }
}
