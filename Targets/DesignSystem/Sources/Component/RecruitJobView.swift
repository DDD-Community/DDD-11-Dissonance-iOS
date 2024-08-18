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
  private let titleLabel: MozipLabel = .init(style: .heading3, color: MozipColor.gray800, text: "모집 직군")
  
  private enum StackViewConstants {
    static let rowHeight: Int = 56
    static let spacing: Int = 12
  }
  
  private let jobGroupStackView: UIStackView = {
    let stackView: UIStackView = .init()
    stackView.axis = .vertical
    stackView.spacing = 12
    stackView.distribution = .fillProportionally
    return stackView
  }()
  
  private let addJobButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("모집 직군 추가하기", for: .normal)
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
  
  private let jobGroupRelay: BehaviorRelay<[BehaviorSubject<(job: String, count: Int)>]> = .init(value: [])
  
  public var allValueObservable: Observable<[(job: String, count: Int)]> {
    jobGroupRelay
      .flatMapLatest {
        Observable.combineLatest($0)
      }
  }
  
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
}

// MARK: - Private Extenion
private extension RecruitJobGroupView {
  func setupViews() {
    addSubview(rootContainer)
    
    rootContainer.flex
      .define {
        $0.addItem(titleLabel)
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
  
  func makeField() {
    let field: TextFieldWithCountView = .init()
    jobGroupStackView.addArrangedSubview(field)
    jobGroupRelay.accept(jobGroupRelay.value + [field.valueSubject])
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
    
    Observable.merge(addJobButton.rx.tap.asObservable(), removeJobButton.rx.tap.asObservable())
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.updatejobGroupStackViewHeight()
        owner.removeJobButton.isHidden = owner.jobGroupRelay.value.count == 1
      })
      .disposed(by: disposeBag)
  }
  
  func removeLastArrangedSubview() {
    guard let lastView = jobGroupStackView.arrangedSubviews.last else {
      return
    }
    jobGroupStackView.removeArrangedSubview(lastView)
    lastView.removeFromSuperview()
    var currentSubjects = jobGroupRelay.value
    currentSubjects.removeLast()
    jobGroupRelay.accept(currentSubjects)
  }
  
  func updatejobGroupStackViewHeight() {
    let newHeight: CGFloat = CGFloat((jobGroupRelay.value.count * StackViewConstants.rowHeight) + (jobGroupRelay.value.count - 1) * StackViewConstants.spacing)
    jobGroupStackView.flex.height(newHeight)
    rootContainer.flex.layout()
    updatedStackViewSubject.onNext(())
  }
}