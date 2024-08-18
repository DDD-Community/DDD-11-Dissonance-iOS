//
//  PostUploadViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DesignSystem
import PhotosUI
import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa

final class PostUploadViewController: BaseViewController<PostUploadReactor>, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: PostUploadCoordinator?
  
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
  private let titleTextFieldView: LabelWithTextFieldView = .init(title: "제목", placeHolder: "공고 제목을 입력해주세요.")
  private let categoryTextFieldView: LabelWithTextFieldView = .init(title: "공고 카테고리", placeHolder: "공고 카테고리를 선택해주세요.")
  private let dropDownIcon: UIImageView = .init(image: MozipImage.dropDownIcon)
  private let categoryView: PostCategoryView = .init()
  private let organizationTextFieldView: LabelWithTextFieldView = .init(title: "기관•단체", placeHolder: "기관•단체 이름을 입력해주세요.")
  private let recruitStartTextFieldView: LabelWithTextFieldView = .init(title: "모집 시작 일자", placeHolder: "모집 시작 일자를 정해주세요.")
  private let recruitEndTextFieldView: LabelWithTextFieldView = .init(title: "모집 마감 일자", placeHolder: "모집 마감 일자를 정해주세요.")
  private let recruitJobView: RecruitJobGroupView = .init()
  private let activityStartTextFieldView: LabelWithTextFieldView = .init(title: "활동 시작 일자", placeHolder: "활동 시작 일자를 정해주세요.")
  private let activityEndTextFieldView: LabelWithTextFieldView = .init(title: "활동 종료 일자", placeHolder: "활동 종료 일자를 정해주세요.")
  private let activityContentsTextView: LabelWithTextView = .init(title: "활동 내용", placeHolder: "자세한 내용을 입력해주세요.")
  private let postUrlTextFieldView: LabelWithTextFieldView = .init(title: "공고 URL", placeHolder: "공고 URL 링크를 입력해주세요.")
  private let bottomShadowView: BottomShadowView = .init()
  private let completionButton: RectangleButton = .init(title: "등록 완료", fontStyle: .heading1, titleColor: .white, backgroundColor: MozipColor.gray200)
  
  // MARK: - Initializer
  init(reactor: PostUploadReactor) {
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    registerKeyboardNotification()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    removeKeyboardNotification()
    coordinator?.didFinish()
  }
  
  override func viewDidLayoutSubviews() {
    scrollView.pin.all(view.pin.safeArea)
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
  }
}

// MARK: - Private Extenion
private extension PostUploadViewController {
  
  // MARK: Properties
  typealias Action = PostUploadReactor.Action
  
  // MARK: Methods
  func bindAction(reactor: PostUploadReactor) {
    titleTextFieldView.textObservable
      .map { Action.inputTitle($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    categoryTextFieldView.textObservable
      .map { Action.inputCategory($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    organizationTextFieldView.textObservable
      .map { Action.inputOrganization($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    recruitStartTextFieldView.textObservable
      .map { Action.inputRecruitStartDate($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    recruitEndTextFieldView.textObservable
      .map { Action.inputRecruitEndDate($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    recruitJobView.allValueObservable
      .map { Action.inputJobGroup($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    activityStartTextFieldView.textObservable
      .map { Action.inputActivityStartDate($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    activityEndTextFieldView.textObservable
      .map { Action.inputActivityEndDate($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    activityContentsTextView.textObservable
      .map { Action.inputActivityContents($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    postUrlTextFieldView.textObservable
      .map { Action.inputPostUrlString($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    completionButton.rx.tap
      .map { Action.didTapCompletionButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: PostUploadReactor) {
    reactor.state
      .map { $0.isEnableComplete }
      .distinctUntilChanged()
      .bind(with: self, onNext: { owner, isEnable in
        owner.updateCompletionButtonState(isEnable)
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
      .map { $0.isSuccessUpload }
      .filter { $0 }
      .bind(with: self, onNext: { owner, _ in
        owner.coordinator?.didSuccessUpload()
      })
      .disposed(by: disposeBag)
  }
  
  func bind() {
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
        owner.present(owner.phPicker, animated: true)
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
        owner.dropDownIcon.image = MozipImage.dropDownActiveIcon
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
  
  func updateCompletionButtonState(_ isEnable: Bool) {
    completionButton.backgroundColor = isEnable ? MozipColor.primary500 : MozipColor.gray200
    completionButton.isEnabled = isEnable
  }
}
  
// MARK: - DatePicker Extenion
private extension PostUploadViewController {
  func setupDatePicker(_ textFieldView: LabelWithTextFieldView) {
    let datePicker: UIDatePicker = .init()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.locale = Locale(identifier: "ko_KR")
    datePicker.minimumDate = Date()
    
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
            let imageData = image.pngData() else {
        return
      }
      
      self.reactor?.action.onNext(.inputImage(imageData))
      
      DispatchQueue.main.async {
        self.imageUploadView.applyImage(image)
      }
    }
  }
}