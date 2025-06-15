//
//  LoginViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import MozipCore
import UIKit
import AuthenticationServices
import DesignSystem

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class LoginViewController: BaseViewController<LoginReactor>, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: LoginCoordinator?
  
  private let navigationBar = MozipNavigationBar(title: "로그인", backgroundColor: .white)
  
  private let logoDescription = MozipLabel(
    style: .heading2,
    color: MozipColor.primary500,
    text: "한눈에 확인하는 IT 대외활동 정보"
  )
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DesignSystemAsset.logoMozip2.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let appleLoginbutton: UIButton = {
    let button: UIButton = .init()
    button.setImage(DesignSystemAsset.appleLoginButton.image, for: .normal)
    return button
  }()
  
  private let kakaoLoginButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(DesignSystemAsset.kakaoLoginButton.image, for: .normal)
    return button
  }()
  
  private let descriptionLabel = MozipLabel(
    style: .caption1,
    color: MozipColor.gray500,
    text: "로그인 시 아래 내용에 동의하는 것으로 간주됩니다."
  )
  
  private let privacyPolicyButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("개인정보 처리방침", for: .normal)
    button.setTitleColor(MozipColor.gray500, for: .normal)
    button.titleLabel?.font = MozipFontStyle.caption1.font
    button.setUnderline()
    return button
  }()
  
  private let termsOfUseButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("이용약관", for: .normal)
    button.setTitleColor(MozipColor.gray500, for: .normal)
    button.titleLabel?.font = MozipFontStyle.caption1.font
    button.setUnderline()
    return button
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음", for: .normal)
    button.setTitleColor(.blue, for: .normal)
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
  
  deinit {
    coordinator?.disappear()
  }
  
  // MARK: - Methods
  override func viewDidLayoutSubviews() {
    setupLayer()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    GA.logScreenView(.로그인화면, screenClass: self)
  }
  
  override func bind(reactor: LoginReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    super.setupViews()
    setupViewHierarchy()
    bind()
  }
  
  private func setupViewHierarchy() {
    rootContainer.flex
      .direction(.column)
      .define { container in
        container.addItem(navigationBar)
        container.addItem().grow(1)
        container.addItem(logoDescription).alignSelf(.center)
        container.addItem(logoImageView).marginTop(16)
        container.addItem().grow(1.88)
        container.addItem(kakaoLoginButton).height(52).marginHorizontal(24).marginTop(20)
        container.addItem(appleLoginbutton).height(52).marginHorizontal(24).marginTop(16)
        container.addItem(descriptionLabel).marginTop(20).alignSelf(.center)
        
        container.addItem()
          .direction(.row)
          .alignSelf(.center)
          .gap(24)
          .marginBottom(16)
          .define { container in
            container.addItem(privacyPolicyButton)
            container.addItem(termsOfUseButton)
          }
      }
  }
  
  private func setupLayer() {
    rootContainer.pin.top().bottom(view.pin.safeArea.bottom).left().right()
    rootContainer.flex.layout()
  }
  
  private func openURL(_ urlString: String) {
    if let url = URL(string: urlString) {
      UIApplication.shared.open(url)
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
  }
  
  func bindState(reactor: LoginReactor) {
    reactor.state
      .map { $0.isSuccessLogin }
      .distinctUntilChanged()
      .filter { $0 }
      .map { _ in Action.fetchUserInfo }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.didFinish }
      .distinctUntilChanged()
      .filter { $0 }
      .bind(with: self, onNext: { owner, _ in
        owner.coordinator?.didFinish()
      })
      .disposed(by: disposeBag)
  }
  
  func bind() {
    navigationBar.backButtonTapObservable
      .asSignal(onErrorJustReturn: ())
      .emit(with: self) { owner, _ in
        owner.coordinator?.didFinish()
      }
      .disposed(by: disposeBag)
    
    privacyPolicyButton.rx.tap
      .asSignal()
      .emit(with: self) { owner, _ in
        owner.coordinator?.pushWebView(urlString: AppProperties.privacyPolicyURLString)
      }
      .disposed(by: disposeBag)
      
    termsOfUseButton.rx.tap
      .asSignal()
      .emit(with: self) { owner, _ in
        owner.coordinator?.pushWebView(urlString: AppProperties.termsOfUseURLString)
      }
      .disposed(by: disposeBag)
  }
}
