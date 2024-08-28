//
//  DefaultViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import PinLayout

class BaseViewController<T: Reactor>: UIViewController, View {
  typealias Reactor = T
  
  // MARK: - Properties
  var disposeBag: DisposeBag = .init()
  let rootContainer: UIView = .init()
  
  // MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
  
  // MARK: - Methods
  func bind(reactor: T) {}
  
  func setupViews() {
    //TODO: 추후 수정
    navigationController?.navigationBar.isHidden = true
    view.backgroundColor = .white
    
    view.addSubview(rootContainer)
  }
}
