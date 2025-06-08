//
//  WebViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/09/25.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DesignSystem
import MozipCore
import UIKit
import WebKit

import PinLayout
import RxSwift
import RxCocoa

final class WebViewController: UIViewController {
  
  // MARK: - Properties
  private let webView: WKWebView = .init()
  private let urlString: String
  private let disposeBag = DisposeBag()
  
  private let stackView: UIStackView = {
    let stackView: UIStackView = .init()
    stackView.distribution = .fillEqually
    stackView.backgroundColor = MozipColor.gray50
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(top: -10, left: 0, bottom: -20, right: 0)
    return stackView
  }()
  
  private let backButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
    button.isEnabled = false
    button.imageView?.tintColor = .lightGray
    return button
  }()
  
  private let forwardButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "arrow.right", withConfiguration: config), for: .normal)
    button.isEnabled = false
    button.imageView?.tintColor = .lightGray
    return button
  }()
  
  private let reloadButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: config), for: .normal)
    button.imageView?.tintColor = .black
    return button
  }()
  
  private let closeButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
    button.imageView?.tintColor = .black
    return button
  }()
  
  // MARK: - Initializer
  init(urlString: String) {
    self.urlString = urlString
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    openWebView()
    bindAction()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    webView.pin.all()
    stackView.pin.left().right().bottom().height(8%)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    GA.logScreenView(.웹뷰화면, screenClass: self)
  }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    backButton.isEnabled = webView.canGoBack
    backButton.imageView?.tintColor = webView.canGoBack ? .black : .lightGray
    forwardButton.isEnabled = webView.canGoForward
    forwardButton.imageView?.tintColor = webView.canGoForward ? .black : .lightGray
  }
}

// MARK: - Private Extenion
private extension WebViewController {
  func setupViews() {
    webView.allowsBackForwardNavigationGestures = true
    webView.navigationDelegate = self
    view.addSubview(webView)
    view.backgroundColor = .white
    webView.addSubview(stackView)
    
    [backButton, forwardButton, reloadButton, closeButton].forEach {
      stackView.addArrangedSubview($0)
    }
  }
  
  func openWebView() {
    guard let url = URL(string: urlString) else {
      return
    }
    
    webView.load(.init(url: url))
  }
  
  func bindAction() {
    backButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.webView.goBack()
      })
      .disposed(by: disposeBag)
    
    forwardButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.webView.goForward()
      })
      .disposed(by: disposeBag)
    
    reloadButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.webView.reload()
      })
      .disposed(by: disposeBag)
    
    closeButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
}
