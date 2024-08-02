//
//  LoginViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class LoginViewController: BaseViewController<LoginReactor>, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: LoginCoordinator?
  
  private let kakaoLoginButton: UIButton = {
    //TODO: - 추후 수정
    let button: UIButton = .init()
    button.setTitle("카카오 로그인", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16)
    button.backgroundColor = .yellow
    return button
  }()
  
  // MARK: - Initializer
  init(reactor: LoginReactor) {
    super.init()
    
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
  }
  
  func bindState(reactor: LoginReactor) {
    reactor.state
      .map { $0.isSuccessLogin }
      .distinctUntilChanged()
      .filter { $0 }
      .bind(with: self, onNext: { owner, _ in
        owner.coordinator?.didSuccessLogin()
      })
      .disposed(by: disposeBag)
  }
}
