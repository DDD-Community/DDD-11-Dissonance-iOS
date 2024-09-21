//
//  PostCategoryView.swift
//  DesignSystem
//
//  Created by 한상진 on 2024/08/14.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer
import UIKit

import FlexLayout
import PinLayout
import RxSwift


public final class PostCategoryView: UIView {
  
  // MARK: - Properties
  private let rootContainer: UIView = .init()
  private let disposeBag: DisposeBag = .init()
  public let selectedCategorySubject: PublishSubject<PostUploadCategory> = .init()
  
  // MARK: - Initializer
  public init() {
    super.init(frame: .zero)
    
    setupViews()
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
private extension PostCategoryView {
  func setupViews() {
    backgroundColor = .white
    layer.borderWidth = 1
    layer.borderColor = MozipColor.gray700.cgColor
    layer.cornerRadius = 8
    isHidden = true
    
    addSubview(rootContainer)
    
    rootContainer.flex
      .define {
        $0.addItem(makeCategoryButton(.contestPlan)).height(54)
        $0.addDivider().marginHorizontal(16)
        $0.addItem(makeCategoryButton(.contestDesign)).height(54)
        $0.addDivider().marginHorizontal(16)
        $0.addItem(makeCategoryButton(.contestIT)).height(54)
        $0.addDivider().marginHorizontal(16)
        $0.addItem(makeCategoryButton(.hackathon)).height(54)
        $0.addDivider().marginHorizontal(16)
        $0.addItem(makeCategoryButton(.club)).height(54)
      }
  }
  
  func makeCategoryButton(_ category: PostUploadCategory) -> UIButton {
    let button: UIButton = {
      let button: UIButton = .init()
      button.setTitle(category.title, for: .normal)
      button.setTitleColor(MozipColor.gray700, for: .normal)
      button.titleLabel?.font = MozipFontStyle.body1.font
      button.contentHorizontalAlignment = .left
      
      var config = UIButton.Configuration.plain()
      config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
      button.configuration = config
      
      return button
    }()
    
    button.rx.tap
      .map { category }
      .bind(to: selectedCategorySubject)
      .disposed(by: disposeBag)
    
    return button
  }
}
