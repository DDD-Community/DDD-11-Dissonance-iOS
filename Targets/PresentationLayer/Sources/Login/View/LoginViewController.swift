//
//  LoginViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

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
      .bind(with: self) { owner, _ in
        owner.appleLoginButtonTapped()
      }
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
  
  func appleLoginButtonTapped() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
}

// MARK: - Apple Login

extension LoginViewController: ASAuthorizationControllerDelegate,
                               ASAuthorizationControllerPresentationContextProviding {
  
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    self.view.window!
  }
  
  func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      let userIdentifier = appleIDCredential.user // jwt 값
      let fn = appleIDCredential.fullName
      let email = appleIDCredential.email
      print("fn:\(fn?.description ?? "NULL") email:\(email ?? "NULL") jwt:\(userIdentifier)")
    case let passwordCredential as ASPasswordCredential:
      let username = passwordCredential.user
      let pass = passwordCredential.password
      print("username:\(username) pass:\(pass)")
    default:
      break
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // TODO: Handle Error
  }
}
