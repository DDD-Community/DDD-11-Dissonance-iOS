//
//  PostRecommendViewController.swift
//  PresentationLayer
//
//  Created by 이원빈 on 2/9/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit
import DesignSystem
import DomainLayer
import PhotosUI

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class PostRecommendViewController: BaseViewController<PostRecommendReactor>, Alertable, Coordinatable {
  
  // MARK: Properties
  weak var coordinator: PostRecommendCoordinator?
  
  // MARK: UI
  private lazy var phPicker: PHPickerViewController = {
    var configuration: PHPickerConfiguration = .init()
    configuration.selectionLimit = 1
    configuration.filter = .images
    let picker = PHPickerViewController(configuration: configuration)
    picker.modalPresentationStyle = .overFullScreen
    picker.delegate = self
    return picker
  }()
  
  private let navigationBar = MozipNavigationBar(
    title: "추천 공고 관리",
    tintColor: MozipColor.gray900,
    backgroundColor: MozipColor.white
  )
  
  private let completeButton: UIButton = {
    let button = UIButton()
    button.setImage(.checkmark, for: .normal)
    button.setTitleColor(MozipColor.primary500, for: .normal)
    return button
  }()
  
  private let postRecommendCollectionView = PostRecommendCollectionView()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  // MARK: Initializer
  init(reactor: PostRecommendReactor) {
    super.init()
    self.reactor = reactor
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: LifeCycle
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    coordinator?.disappear()
  }
  
  // MARK: Overrides
  override func bind(reactor: PostRecommendReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindViews()
  }
  
  override func setupViews() {
    super.setupViews()
    setupNavigationBar()
  }
  
  override func viewDidLayoutSubviews() {
    setupViewLayout()
  }
  
  // MARK: Methods
  private func setupNavigationBar() {
    navigationBar.setRightButtons([completeButton])
  }
}

// MARK: - Private Extenion
private extension PostRecommendViewController {
  
  // MARK: Properties
  typealias Action = PostRecommendReactor.Action
  typealias State = PostRecommendReactor.State
  
  // MARK: Methods
  func bindAction(reactor: PostRecommendReactor) {
    rx.viewDidAppear
      .take(1)
      .map { Action.askHistoryIfExist }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    completeButton.rx.tap
      .map { Action.completeButtonDidTap }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: PostRecommendReactor) {
    
    reactor.state
      .map(\.isLoading)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive {
        $0 ? LoadingIndicator.start(withDimming: true) : LoadingIndicator.stop()
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isUploadComplete)
      .distinctUntilChanged()
      .filter { $0 }
      .asSignal(onErrorJustReturn: true)
      .emit(with: self) { owner, _ in
        owner.coordinator?.didFinish()
      }
      .disposed(by: disposeBag)
      
    reactor.state
      .map(\.posts)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(with: self) { owner, data in
        owner.postRecommendCollectionView.setupData(data)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isUploadable)
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: true)
      .emit(to: completeButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.alertHistoryData)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .filter { $0 }
      .drive(with: self) { owner, _ in
        owner.showHistoryAlert()
      }
      .disposed(by: disposeBag)
  }
  
  func bindViews() {
    navigationBar.backButtonTapObservable
      .bind(with: self) { owner, _ in
        owner.coordinator?.didFinish()
      }
      .disposed(by: disposeBag)
    
    postRecommendCollectionView.editButtonTapRelay
      .asSignal()
      .emit(with: self) { owner, index in
        owner.coordinator?.pushPostSearch(at: index)
      }
      .disposed(by: disposeBag)
    
    postRecommendCollectionView.thumbnailImageTapRelay
      .asSignal()
      .emit(with: self) { owner, index in
        print(index)
        owner.reactor?.action.onNext(.imageViewDidTap(index))
        owner.checkPhotoLibraryPermission()
      }
      .disposed(by: disposeBag)
  }
  
  func showHistoryAlert() {
    presentAlert(
      type: .loadCache,
      leftButtonAction: { [weak self] in
        self?.reactor?.action.onNext(.loadData)
      } ,
      rightButtonAction: { [weak self] in
        self?.reactor?.action.onNext(.loadCache)
      })
  }
}

extension PostRecommendViewController { // TODO: Util 로 분리 필요
  func checkPhotoLibraryPermission() {
    let status = PHPhotoLibrary.authorizationStatus()
    
    switch status {
    case .notDetermined:        requestPhotoAuthorization()
    case .authorized, .limited: present(phPicker, animated: true)
    case .denied, .restricted:  showPermissionDeniedAlert()
    default: break
    }
  }
  
  func requestPhotoAuthorization() {
    PHPhotoLibrary.requestAuthorization { newStatus in
      DispatchQueue.main.async { [weak self] in
        if newStatus == .authorized || newStatus == .limited {
          guard let self else { return }
          present(phPicker, animated: true)
        } else {
          self?.showPermissionDeniedAlert()
        }
      }
    }
  }
  
  func showPermissionDeniedAlert() {
    presentAlert(type: .photoPermissionDenied, rightButtonAction: {
      guard let appSettings = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
    })
  }
}

// MARK: - PHPicker Extenion
extension PostRecommendViewController: PHPickerViewControllerDelegate {
  internal func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    
    guard let provider = results.first?.itemProvider,
          provider.canLoadObject(ofClass: UIImage.self) else {
      return
    }
    
    provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
      guard let self = self,
            let image = image as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.5) else {
        return
      }
      
      guard imageData.count < 10 * 1024 * 1024 else {
        DispatchQueue.main.async { [weak self] in
          self?.presentAlert(type: .imageSizeOver, rightButtonAction: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
              guard let self else { return }
              present(phPicker, animated: true)
            }
          })
        }
        return
      }
      
      self.reactor?.action.onNext(.inputImage(imageData))
    }
  }
}

// MARK: - Layout
private extension PostRecommendViewController {
  func setupViewHierarchy() {
    view.addSubview(postRecommendCollectionView)
    view.addSubview(navigationBar)
  }
  
  func setupViewLayout() {
    postRecommendCollectionView.pin.top(to: navigationBar.edge.bottom).left().right().bottom()
    navigationBar.pin.top().left().right().sizeToFit(.content)
    navigationBar.layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: 4, blur: 8, spread: 0)
  }
}
