//
//  ImageViewController.swift
//  PresentationLayer
//
//  Created by 이원빈 on 10/30/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit
import DesignSystem
import MozipCore

import RxSwift
import RxCocoa

final class ImageViewController: UIViewController {
  
  // MARK: - Properties
  public let dismissRelay: PublishRelay<Void> = .init()
  private let disposeBag = DisposeBag()
  private var initialTouchPoint: CGPoint = .init(x: 0, y: 0)
  
  // MARK: UI 컴포넌트
  private let navigationBar: MozipNavigationBar = {
    let navigationBar = MozipNavigationBar(title: " ", backgroundColor: .black)
    navigationBar.setLeftButton(image: UIImage(systemName: "xmark")!, color: .white)
    return navigationBar
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView: UIScrollView = .init()
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 3.0
    return scrollView
  }()
  
  private let imageView: UIImageView = {
    let imageView: UIImageView = .init()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  // MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
    scrollView.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    bindViews()
    setupPanGesture()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    navigationBar.pin.top().left().right()
    scrollView.pin.top(to: navigationBar.edge.bottom).left().right().bottom(view.safeAreaInsets.bottom)
    imageView.pin.all()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    GA.logScreenView(.공고이미지화면, screenClass: self)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.imageView.frame.origin = .init(x: 0, y: 0)
  }
  
  // MARK: - Methods
  public func setImage(_ uiImage: UIImage) {
    imageView.image = uiImage
  }
  
  private func setupViews() {
    view.addSubview(navigationBar)
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
  }
  
  private func bindViews() {
    navigationBar.backButtonTapObservable
      .asSignal(onErrorJustReturn: ())
      .emit(to: dismissRelay)
      .disposed(by: disposeBag)
  }
  
  private func setupPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    view.addGestureRecognizer(panGesture)
  }
  
  @objc // FIXME: 추후 Rx 스타일로 변경
  private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    let touchPoint = gesture.location(in: view.window)
    let viewWidth = imageView.frame.size.width
    let viewHeight = imageView.frame.size.height
    
    switch gesture.state {
    case .began:
      initialTouchPoint = touchPoint
    case .changed:
      if touchPoint.y - initialTouchPoint.y > 0 {
        imageView.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: viewWidth, height: viewHeight)
      }
    case .ended, .cancelled:
      if touchPoint.y - initialTouchPoint.y > 100 {
        dismissRelay.accept(())
      } else {
        UIView.animate(withDuration: 0.3) {
          self.imageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        }
      }
    default:
      break
    }
  }
}

// MARK: - UIScrollViewDelegate
extension ImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
