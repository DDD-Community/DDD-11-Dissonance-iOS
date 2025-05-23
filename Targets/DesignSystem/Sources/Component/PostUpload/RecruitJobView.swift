//
//  RecruitJobView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/15.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxRelay
import RxSwift


public final class RecruitJobGroupView: UIView {
  
  // MARK: - Properties
  private let rootContainer: UIView = .init()
  private let titleLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "모집 대상")
  private let requiredLabel: MozipLabel = .init(style: .heading3, color: MozipColor.primary500, text: " *")
  
  private enum StackViewConstants {
    static let rowHeight: Int = 56
    static let spacing: Int = 12
  }
  
  private let jobGroupStackView: UIStackView = {
    let stackView: UIStackView = .init()
    stackView.axis = .vertical
    stackView.spacing = 12
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let addJobButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("모집 대상 추가하기", for: .normal)
    button.setTitleColor(MozipColor.gray500, for: .normal)
    button.titleLabel?.font = MozipFontStyle.body1.font
    return button
  }()
  
  private let removeJobButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("삭제하기", for: .normal)
    button.setTitleColor(MozipColor.gray500, for: .normal)
    button.titleLabel?.font = MozipFontStyle.body1.font
    button.isHidden = true
    return button
  }()
  
  public let jobGroupRelay: BehaviorRelay<[String]> = .init(value: [])
  
  public let updatedStackViewSubject: PublishSubject<Void> = .init()
  private let disposeBag: DisposeBag = .init()
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    
    makeField()
    setupViews()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  // MARK: - Methods
  public func setEditMode() {
    jobGroupStackView.arrangedSubviews.first?.removeFromSuperview()
    jobGroupRelay.accept(Array(jobGroupRelay.value.dropFirst()))
  }
  
  public func makeField(value: String = "") {
    jobGroupRelay.accept(jobGroupRelay.value + [value])
    
    let textField: MozipTextField = .init(placeHolder: "모집 대상을 입력해주세요. (공백 포함 최대 25자)")
    textField.tag = jobGroupRelay.value.count - 1
    jobGroupStackView.addArrangedSubview(textField)
    
    textField.rx.text.orEmpty
      .skip(1)
      .filter { [weak self] in self?.checkTextCount(textField, text: $0) ?? false }
      .compactMap { [weak self] text in self?.updateJobGroupArray(tag: textField.tag, text: text) }
      .bind(to: jobGroupRelay)
      .disposed(by: disposeBag)
    
    if !value.isEmpty {
      textField.rx.text.onNext(value)
    }
  }
}

// MARK: - Private Extenion
private extension RecruitJobGroupView {
  func setupViews() {
    addSubview(rootContainer)
    
    rootContainer.flex
      .define {
        $0.addItem()
          .direction(.row)
          .define {
            $0.addItem(titleLabel)
            $0.addItem(requiredLabel)
          }
        $0.addItem(jobGroupStackView).marginTop(12).height(56)
        
        $0.addItem()
          .marginTop(24)
          .direction(.row)
          .justifyContent(.spaceBetween)
          .define {
            $0.addItem(addJobButton).marginLeft(34.6%)
            $0.addItem(removeJobButton)
          }
      }
  }
  
  func bind() {
    addJobButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.makeField()
      })
      .disposed(by: disposeBag)
    
    removeJobButton.rx.tap
      .withUnretained(self)
      .filter { owner, _ in owner.jobGroupRelay.value.count > 1 }
      .asSignal(onErrorSignalWith: .empty())
      .emit { owner, _ in
        owner.removeLastArrangedSubview()
      }
      .disposed(by: disposeBag)
    
    jobGroupRelay
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.updatejobGroupStackViewHeight()
        owner.removeJobButton.isHidden = owner.jobGroupRelay.value.count == 1
      })
      .disposed(by: disposeBag)
  }
  
  func removeLastArrangedSubview() {
    guard let lastView = jobGroupStackView.arrangedSubviews.last else { return }
    jobGroupStackView.removeArrangedSubview(lastView)
    lastView.removeFromSuperview()
    jobGroupRelay.accept(jobGroupRelay.value.dropLast())
  }
  
  func updatejobGroupStackViewHeight() {
    let newHeight: CGFloat = CGFloat((jobGroupRelay.value.count * StackViewConstants.rowHeight) + (jobGroupRelay.value.count - 1) * StackViewConstants.spacing)
    jobGroupStackView.flex.height(newHeight)
    rootContainer.flex.layout()
    updatedStackViewSubject.onNext(())
  }
  
  func checkTextCount(_ textField: UITextField, text: String) -> Bool {
    guard text.count > 25 else { return true }
    
    textField.text = text.dropLast().map { String($0) }.joined()
    return false
  }
  
  func updateJobGroupArray(tag: Int, text: String) -> [String] {
    var jobGroupArray = jobGroupRelay.value
    guard tag < jobGroupArray.count else { return jobGroupArray }
    
    jobGroupArray[tag] = text
    return jobGroupArray
  }
}
