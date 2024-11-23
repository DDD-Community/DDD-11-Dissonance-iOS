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
  case deletePost
  case logout
  case deleteAccount
  case photoPermissionDenied
  case imageSizeOver
  
  var title: String {
    switch self {
    case .report: "해당 공고를 신고하시겠습니까?"
    case .deletePost: "해당 공고를 삭제하시겠습니까?"
    case .logout: "로그아웃 하시겠습니까?"
    case .deleteAccount: "정말 탈퇴하시겠습니까?"
    case .photoPermissionDenied: "권한 필요"
    case .imageSizeOver: "이미지 사이즈 초과"
    }
  }
  
  var message: String {
    switch self {
    case .report: "신고 접수 후 이후 조치까지\n영업일 기준 최소 3일 이상 소요될 수 있습니다."
    case .deletePost: "해당 공고를 삭제할 경우,\n복구가 어려우니 신중하게 선택해주세요."
    case .logout: ""
    case .deleteAccount: "탈퇴하기 버튼 선택 시,\n계정은 삭제되며 복구할 수 없습니다."
    case .photoPermissionDenied: "사진첩에 접근할 수 없습니다.\n설정에서 권한을 허용해 주세요."
    case .imageSizeOver: "공고 이미지는 10MB 이하의 사진만\n업로드할 수 있습니다."
    }
  }
  
  var leftButtonTitle: String {
    switch self {
    case .photoPermissionDenied, .imageSizeOver: "확인"
    default: "취소하기"
    }
  }
  
  var rightButtonTitle: String {
    switch self {
    case .report: "신고하기"
    case .deletePost: "삭제하기"
    case .logout: "로그아웃"
    case .deleteAccount: "탈퇴하기"
    case .photoPermissionDenied: "설정으로 이동"
    case .imageSizeOver: "다시 선택하기"
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
