//
//  LoginViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DesignSystem
import UIKit
import AuthenticationServices

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class LoginViewController: BaseViewController<LoginReactor>, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: LoginCoordinator?
  
  private let appleLoginbutton: UIButton = {
    //TODO: - 추후 수정
    let button: UIButton = .init()
    button.setTitle("애플 로그인", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16)
    button.backgroundColor = .black
    return button
  }()
  
  private let kakaoLoginButton: UIButton = {
    //TODO: - 추후 수정
    let button: UIButton = .init()
    button.setTitle("카카오 로그인", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16)
    button.backgroundColor = .yellow
    return button
  }()
  
  let temp: UILabel = {
    let label: UILabel = .init()
    label.font = MozipFontStyle.heading1.font
    label.textAlignment = .center
    label.text = "액세스 토큰 자리"
    label.numberOfLines = 0
    label.isUserInteractionEnabled = true
    return label
  }()
  
  // MARK: - Initializer
  init(reactor: LoginReactor) {
    super.init()
    
    self.reactor = reactor
    view.addSubview(temp)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    temp.pin.horizontally().marginHorizontal(20).height(300).vCenter()
  }
  
  // MARK: - Methods
  override func bind(reactor: LoginReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    super.setupViews()
    
    // TODO: 추후 수정
    rootContainer.flex
      .direction(.column)
      .justifyContent(.end)
      .define { container in
        container.addItem(kakaoLoginButton).marginHorizontal(50).marginTop(20)
        container.addItem(appleLoginbutton).marginHorizontal(50).marginTop(10)
      }
  }
}

// MARK: - Private Extenion
private extension LoginViewController {
  
  // MARK: Properties
  typealias Action = LoginReactor.Action
  typealias State = LoginReactor.State
  
  // MARK: Methods
  func bindAction(reactor: LoginReactor) {
    kakaoLoginButton.rx.tap
      .asSignal()
      .map { Action.didTapKakaoLoginButton }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
    
    appleLoginbutton.rx.tap
      .asSignal()
      .map { Action.didTapAppleLoginButton }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
    
    temp.rxGesture.tap
      .bind(with: self, onNext: { owner, _ in
        UIPasteboard.general.string = owner.temp.text
      })
      .disposed(by: disposeBag)

  }
  
  func bindState(reactor: LoginReactor) {
    reactor.state
      .map { $0.accessToken }
      .distinctUntilChanged()
      .filter { !$0.isEmpty }
      .bind(with: self, onNext: { owner, token in
        owner.temp.text = token
      })
      .disposed(by: disposeBag)
  }
}
