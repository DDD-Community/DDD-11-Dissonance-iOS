//
//  MozipAlertController.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxSwift

public final class MozipAlertController: UIViewController {
  
  // MARK: - Properties
  private let alertView: MozipAlertView
  public var leftButtonAction: () -> Void = {}
  public var rightButtonAction: () -> Void = {}
  private let disposeBag: DisposeBag = .init()
  
  // MARK: - Initializer
  public init(title: String, message: String, leftButtonTitle: String, rightbuttonTitle: String) {
    self.alertView = .init(
      title: title,
      message: message,
      leftButtonTitle: leftButtonTitle,
      rightbuttonTitle: rightbuttonTitle
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(alertView)
    bind()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    alertView.pin.all()
    alertView.flex.layout()
  }
}

// MARK: - Private Extenion
private extension MozipAlertController {
  func bind() {
    alertView.leftButtonTabObservable
      .bind(with: self, onNext: { owner, _ in
        owner.leftButtonAction()
        owner.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    alertView.rightButtonTabObservable
      .bind(with: self, onNext: { owner, _ in
        owner.rightButtonAction()
        owner.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
}
