//
//  TermsPolicyViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/09/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import Core
import UIKit
import DesignSystem

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class TermsPolicyViewController: UIViewController, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: TermsPolicyCoordinator?
  private let navigationBar = MozipNavigationBar(title: "약관 및 정책", backgroundColor: .white)
  private let disposeBag = DisposeBag()
  
  private let termsOfUseButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("서비스 이용약관", for: .normal)
    button.setTitleColor(MozipColor.gray800, for: .normal)
    button.titleLabel?.font = MozipFontStyle.body1.font
    return button
  }()
  
  private let privacyPolicyButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("개인정보 처리방침", for: .normal)
    button.setTitleColor(MozipColor.gray800, for: .normal)
    button.titleLabel?.font = MozipFontStyle.body1.font
    return button
  }()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    bind()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    coordinator?.disappear()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    navigationBar.pin.top().left().right()
    termsOfUseButton.pin.top(to: navigationBar.edge.bottom).marginTop(4).left().marginLeft(20).height(46).sizeToFit(.height)
    privacyPolicyButton.pin.top(to: termsOfUseButton.edge.bottom).left().marginLeft(20).height(46).sizeToFit(.height)
  }
}

// MARK: - Private Extenion
  private extension TermsPolicyViewController {
    func setupViews() {
      view.backgroundColor = .white
      view.addSubview(navigationBar)
      view.addSubview(termsOfUseButton)
      view.addSubview(privacyPolicyButton)
    }
    
    func bind() {
      navigationBar.backButtonTapObservable
        .asSignal(onErrorSignalWith: .empty())
        .emit(with: self) { owner, _ in
          owner.coordinator?.didFinish()
        }
        .disposed(by: disposeBag)
      
      termsOfUseButton.rx.tap
        .asSignal()
        .emit(with: self) { owner, _ in
          owner.coordinator?.pushWebView(urlString: AppProperties.termsOfUseURLString)
        }
        .disposed(by: disposeBag)
      
      privacyPolicyButton.rx.tap
        .asSignal()
        .emit(with: self) { owner, _ in
          owner.coordinator?.pushWebView(urlString: AppProperties.privacyPolicyURLString)
        }
        .disposed(by: disposeBag)
    }
  }
