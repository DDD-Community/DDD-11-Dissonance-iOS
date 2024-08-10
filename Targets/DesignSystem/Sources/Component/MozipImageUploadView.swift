//
//  MozipImageUploadView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/10.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

public final class MozipImageUploadView: UIView {
  
  // MARK: - Properties
  private let rootContainer: UIView = .init()
  
  private let descriptionLabel: MozipLabel = {
    let label: MozipLabel = .init(style: .body1, color: MozipColor.gray400, text: "공고를 대표하는\n이미지를 업로드해주세요")
    label.textAlignment = .center
    return label
  }()
  
  private let uploadButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("업로드", for: .normal)
    button.setTitleColor(MozipColor.gray10, for: .normal)
    button.titleLabel?.font = .pretendard.semiBold.font(size: 16)
    button.backgroundColor = MozipColor.gray800
    return button
  }()
  
  private let disposeBag: DisposeBag = .init()
  
  public let uploadButtonTapSubject: PublishSubject<Void> = .init()
  
  // MARK: - Initializer
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.vertically(70)
    rootContainer.flex.layout()
    
    uploadButton.layer.cornerRadius = uploadButton.bounds.height * 0.5
  }
}

// MARK: - Private Extenion
private extension MozipImageUploadView {
  func setupViews() {
    backgroundColor = MozipColor.gray10
    
    rootContainer.flex
      .alignItems(.center)
      .define {
        $0.addItem(descriptionLabel)
        $0.addItem(uploadButton).marginTop(16).width(23%).height(38.7%)
      }
    
    addSubview(rootContainer)
  }
  
  func bind() {
    uploadButton.rx.tap
      .bind(to: uploadButtonTapSubject)
      .disposed(by: disposeBag)
  }
}
