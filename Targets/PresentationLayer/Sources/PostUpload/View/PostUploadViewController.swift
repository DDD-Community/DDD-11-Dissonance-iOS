//
//  PostUploadViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DesignSystem
import DomainLayer
import PhotosUI
import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class PostUploadViewController: BaseViewController<PostUploadReactor>, Alertable, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: PostUploadCoordinator?
  private let navigationBar: MozipNavigationBar
  private var isEnableComplete: Bool = false
  private var originalCenter: CGPoint?

  private let scrollView: UIScrollView = {
    let scrollView: UIScrollView = .init()
    scrollView.bounces = false
    return scrollView
  }()
  
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter: DateFormatter = .init()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
    return dateFormatter
  }()
  
  private lazy var phPicker: PHPickerViewController = {
    var configuration: PHPickerConfiguration = .init()
    configuration.selectionLimit = 1
    configuration.filter = .images
    let picker = PHPickerViewController(configuration: configuration)
    picker.modalPresentationStyle = .overFullScreen
    picker.delegate = self
    return picker
  }()
  
  private var bottomBlankHeight: CGFloat {
    CGFloat(view.frame.height * 0.127 + 25)
  }
  
  // MARK: UI 컴포넌트
  private let imageUploadView: ImageUploadView = .init(frame: .zero)
  private let titleTextFieldView: LabelWithTextFieldView = .init(title: "제목", placeHolder: "공고 제목을 입력해주세요.", isRequired: true)
  private let categoryTextFieldView: LabelWithTextFieldView = .init(title: "공고 카테고리", placeHolder: "공고 카테고리를 선택해주세요.", isRequired: true)
  private let dropDownIcon: UIImageView = .init(image: DesignSystemAsset.dropDownIcon.image)
  private let categoryView: PostCategoryView = .init()
  private let organizationTextFieldView: LabelWithTextFieldView = .init(title: "기관•단체", placeHolder: "기관•단체 이름을 입력해주세요.", isRequired: true)
  private let recruitStartTextFieldView: LabelWithTextFieldView = .init(title: "모집 시작 일자", placeHolder: "모집 시작 일자를 정해주세요.")
  private let recruitEndTextFieldView: LabelWithTextFieldView = .init(title: "모집 마감 일자", placeHolder: "모집 마감 일자를 정해주세요.", isRequired: true)
  private let recruitJobView: RecruitJobGroupView = .init()
  private let activityStartTextFieldView: LabelWithTextFieldView = .init(title: "활동 시작 일자", placeHolder: "활동 시작 일자를 정해주세요.")
  private let activityEndTextFieldView: LabelWithTextFieldView = .init(title: "활동 종료 일자", placeHolder: "활동 종료 일자를 정해주세요.")
  private let activityContentsTextView: LabelWithTextView = .init(title: "활동 내용", placeHolder: "자세한 내용을 입력해주세요.", isRequired: true)
  private let postUrlTextFieldView: LabelWithTextFieldView = .init(title: "공고 URL", placeHolder: "공고 URL 링크를 입력해주세요.", isRequired: true)
  private let bottomShadowView: BottomShadowView = .init()
  private let completionButton: RectangleButton = .init(fontStyle: .heading1, titleColor: .white, backgroundColor: MozipColor.gray200)
  
  // MARK: - Initializer
  init(reactor: PostUploadReactor) {
    navigationBar = .init(title: "공고 등록", backgroundColor: .white)
    super.init()
    
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    [recruitStartTextFieldView,
     recruitEndTextFieldView,
     activityStartTextFieldView,
     activityEndTextFieldView
    ].forEach {
      setupDatePicker($0)
    }
    
    setupOriginPost()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    registerKeyboardNotification()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    removeKeyboardNotification()
    coordinator?.didFinish()
  }
  
  override func viewDidLayoutSubviews() {
    navigationBar.pin.top().left().right()
    scrollView.pin.top(to: navigationBar.edge.bottom).left().right().bottom(to: bottomShadowView.edge.top)
    rootContainer.pin.top().left().right()
    rootContainer.flex.layout(mode: .adjustHeight)
    scrollView.contentSize = rootContainer.frame.size
    
    dropDownIcon.pin.right(16).vertically(16)
    categoryView.pin.below(of: categoryTextFieldView).marginTop(12).horizontally(20).height(274)
    bottomShadowView.pin.bottom().left().right().height(12.7%)
    completionButton.pin.top(12).horizontally(23).height(57.4%)
  }
  
  // MARK: - Methods
  override func bind(reactor: PostUploadReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bind()
  }
  
  override func setupViews() {
    super.setupViews()
    
    view.addSubview(scrollView)
    scrollView.addSubview(rootContainer)
    categoryTextFieldView.textField.addSubview(dropDownIcon)
    view.addSubview(bottomShadowView)
    completionButton.updateTitle((reactor?.post.title.isEmpty ?? true) ? "등록 완료" : "수정 완료")
    bottomShadowView.addSubview(completionButton)
    
    rootContainer.flex
      .define {
        $0.addItem(imageUploadView).aspectRatio(1.0)
        $0.addItem(titleTextFieldView).marginTop(32).marginHorizontal(20).height(90)
        $0.addItem(categoryTextFieldView).marginTop(32).marginHorizontal(20).height(90)
        $0.addItem(organizationTextFieldView).marginTop(32).marginHorizontal(20).height(90)
        $0.addDivider().marginTop(32).marginHorizontal(20)
        $0.addItem(recruitStartTextFieldView).marginTop(32).marginHorizontal(20).height(90)
        $0.addItem(recruitEndTextFieldView).marginTop(32).marginHorizontal(20).height(90)
        $0.addItem(recruitJobView).marginTop(32).marginHorizontal(20)
        $0.addDivider().marginTop(32).marginHorizontal(20)
        $0.addItem(activityStartTextFieldView).marginTop(32).marginHorizontal(20).height(90)
        $0.addItem(activityEndTextFieldView).marginTop(32).marginHorizontal(20).height(90)
        $0.addDivider().marginTop(32).marginHorizontal(20)
        $0.addItem(activityContentsTextView).marginTop(32).marginHorizontal(20).height(274)
        $0.addItem(postUrlTextFieldView).marginTop(32).marginHorizontal(20).height(90).marginBottom(bottomBlankHeight)
      }
    rootContainer.addSubview(categoryView)
    view.addSubview(navigationBar)
  }
}

// MARK: - Private Extenion
private extension PostUploadViewController {
  
  // MARK: Properties
  typealias Action = PostUploadReactor.Action
  
  var uploadBinder: Binder<MozipNetworkResult> {
    return .init(self) { owner, uploadResult in
      switch uploadResult {
      case .success:
        owner.coordinator?.didFinish()
        
        if owner.reactor?.originID != nil {
          owner.navigationController?.view.showToast(message: "공고 수정이 완료되었습니다.")
        }
        
      case .error(let message):
        guard let message else { return }
        owner.view.showToast(message: message)
      }
    }
  }
  
  // MARK: Methods
  func setupOriginPost() {
    guard let originPost = reactor?.post, !originPost.title.isEmpty else { return }
    
    let originPostValues = [
      originPost.title,
      originPost.category?.title ?? originPost.categoryTitle,
      originPost.organization,
      originPost.recruitStartDate,
      originPost.recruitEndDate,
      originPost.activityStartDate,
      originPost.activityEndDate,
      originPost.postUrlString
    ]
    
    let textFieldViews: [LabelWithTextFieldView] = [
      titleTextFieldView,
      categoryTextFieldView,
      organizationTextFieldView,
      recruitStartTextFieldView,
      recruitEndTextFieldView,
      activityStartTextFieldView,
      activityEndTextFieldView,
      postUrlTextFieldView
    ]
    
    guard originPostValues.count == textFieldViews.count else { return }
    
    for i in 0..<originPostValues.count {
      textFieldViews[i].textField.rx.text.onNext(originPostValues[i])
    }
    
    recruitJobView.setEditMode()
    originPost.jobGroups.forEach {
      recruitJobView.makeField(value: $0)
    }
    
    activityContentsTextView.textView.rx.text.onNext(originPost.activityContents)
    reactor?.action.onNext(.inputImage(originPost.imageData))
    
    DispatchQueue.main.async {
      self.imageUploadView.applyImage(UIImage(data: originPost.imageData) ?? .init())
    }
  }
  
  func bindAction(reactor: PostUploadReactor) {
    titleTextFieldView.textObservable
      .skip(1)
      .map { Action.inputTitle($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    categoryTextFieldView.textObservable
      .skip(1)
      .map { Action.inputCategory($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    organizationTextFieldView.textObservable
      .skip(1)
      .map { Action.inputOrganization($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    recruitStartTextFieldView.textObservable
      .skip(1)
      .map { Action.inputRecruitStartDate($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    recruitEndTextFieldView.textObservable
      .skip(1)
      .map { Action.inputRecruitEndDate($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    recruitJobView.jobGroupRelay
      .skip(1)
      .map { Action.inputJobGroup($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    activityStartTextFieldView.textObservable
      .skip(1)
      .map { Action.inputActivityStartDate($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    activityEndTextFieldView.textObservable
      .skip(1)
      .map { Action.inputActivityEndDate($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    activityContentsTextView.textObservable
      .skip(1)
      .map { Action.inputActivityContents($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    postUrlTextFieldView.textObservable
      .skip(1)
      .map { Action.inputPostUrlString($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    completionButton.rx.tap
      .withUnretained(self)
      .filter { owner, _ in !owner.isEnableComplete }
      .asSignal(onErrorSignalWith: .empty())
      .emit { (owner, _) in
        owner.view.showToast(message: "모든 항목을 입력해 주세요.")
      }
      .disposed(by: disposeBag)
    
    completionButton.rx.tap
      .withUnretained(self)
      .filter { owner, _ in owner.isEnableComplete }
      .map { _ in Action.didTapCompletionButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: PostUploadReactor) {
    reactor.state
      .map { $0.isEnableComplete }
      .distinctUntilChanged()
      .bind(with: self, onNext: { owner, isEnable in
        let color = isEnable ? MozipColor.primary500 : MozipColor.gray200
        owner.completionButton.backgroundColor = color
        owner.isEnableComplete = isEnable
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .bind(with: self, onNext: { owner, isLoading in
        // TODO: 서버 통신 시간 동안의 액션 추가 예정
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.uploadResult }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(to: uploadBinder)
      .disposed(by: disposeBag)
  }
  
  func bind() {
    navigationBar.backButtonTapObservable
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.coordinator?.didFinish()
      })
      .disposed(by: disposeBag)
    
    scrollView.rxGesture.tap
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.categoryView.isHidden = true
        owner.view.endEditing(true)
      })
      .disposed(by: disposeBag)
    
    imageUploadView.uploadButtonTapObservable
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.checkPhotoLibraryPermission()
      })
      .disposed(by: disposeBag)
    
    categoryTextFieldView.textField.rxGesture.tap
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.categoryView.isHidden.toggle()
      })
      .disposed(by: disposeBag)
    
    categoryView.selectedCategorySubject
      .map { $0.title }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, title in
        owner.categoryTextFieldView.textField.rx.text.onNext(title)
        owner.categoryTextFieldView.textField.sendActions(for: .editingDidEnd)
        owner.dropDownIcon.image = DesignSystemAsset.dropDownActiveIcon.image
        owner.categoryView.isHidden.toggle()
      })
      .disposed(by: disposeBag)
    
    categoryTextFieldView.textField.rxGesture.tap
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.categoryView.isHidden.toggle()
      })
      .disposed(by: disposeBag)
    
    recruitJobView.updatedStackViewSubject
      .asSignal(onErrorJustReturn: ())
      .emit(with: self, onNext: { owner, _ in
        owner.updateLayout()
      })
      .disposed(by: disposeBag)
  }
  
  func updateLayout() {
    rootContainer.flex.layout(mode: .adjustHeight)
    scrollView.contentSize = rootContainer.frame.size
    categoryView.pin.below(of: categoryTextFieldView).marginTop(12).horizontally(20).height(274)
  }
}
  
// MARK: - DatePicker Extenion
private extension PostUploadViewController {
  func setupDatePicker(_ textFieldView: LabelWithTextFieldView) {
    let datePicker: UIDatePicker = .init()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .inline
    datePicker.locale = Locale(identifier: "ko_KR")
    
    if let backgroundView = datePicker.subviews.first?.subviews.first {
      backgroundView.backgroundColor = .white
    }
    
    textFieldView.textField.inputView = datePicker
    setupDatePickerAccessory(textFieldView)
  }
  
  func setupDatePickerAccessory(_ textFieldView: LabelWithTextFieldView) {
    let textField: UITextField = textFieldView.textField
    let accessoryStackView: DatePickerAccessoryView = .init()
    textField.inputAccessoryView = accessoryStackView
    
    accessoryStackView.cancelButtonTapObservable
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, date in
        textField.resignFirstResponder()
      })
      .disposed(by: disposeBag)
    
    accessoryStackView.completionButtonTapObservable
      .map { (textField.inputView as? UIDatePicker)?.date ?? .init() }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, date in
        textField.rx.text.onNext(owner.dateFormatter.string(from: date))
        textField.sendActions(for: .editingDidEnd)
        textField.resignFirstResponder()
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Keyboard Extenion
private extension PostUploadViewController {
  func registerKeyboardNotification() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, notification in
        owner.keyboardWillShow(notification)
      })
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.view.transform = .identity
        owner.view.center = owner.originalCenter ?? .zero
      })
      .disposed(by: disposeBag)
  }
  
  func removeKeyboardNotification() {
    NotificationCenter.default.removeObserver(self)
  }
  
  func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let textAreaView = view.firstResponder(),
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }

    originalCenter = view.center
    let textAreaY = textAreaView.convert(textAreaView.bounds, to: view).origin.y
    let keyboardHeight = keyboardFrame.cgRectValue.height
    
    guard (textAreaY + textAreaView.frame.height) >= (view.frame.height - keyboardHeight) else {
      return
    }
    
    view.transform = CGAffineTransform(
      translationX: 0,
      y: 24 - keyboardHeight
    )
  }
  
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
extension PostUploadViewController: PHPickerViewControllerDelegate {
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
      
      DispatchQueue.main.async {
        self.imageUploadView.applyImage(image)
      }
    }
  }
}
