//
//  HomeSkeletonView.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/21/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

public final class HomeSkeleton: UIView {
  
  private enum Metric {
    static let horizontalPadding: CGFloat = 20
  }
  
  // MARK: - UI
  private let rootFlexContainer = UIView()
  
  // MARK: - Initializers
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  public override func layoutSubviews() {
    super.layoutSubviews()
    setupLayout()
  }
  
  // MARK: - Methods
  
  public func hide() {
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 0
    }, completion: { _ in
      self.removeFromSuperview()
    })
  }
  
  private func setupViewHierarchy() {
    addSubview(rootFlexContainer)
    rootFlexContainer.flex
      .direction(.column)
      .marginHorizontal(Metric.horizontalPadding)
      .define { flex in
        makeBanner(from: flex)
        makeSection(from: flex)
        makeSection(from: flex)
      }
  }
  
  private func setupLayout() {
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
  }
  
  @discardableResult
  private func makeBanner(from flex: Flex) -> Flex {
    flex.addItem().direction(.column).define { flex in
      flex.addFakeView().width(130).height(20).marginTop(32)
      flex.addFakeView().width(Device.width-40).aspectRatio(2).marginTop(24)
    }
  }
  
  @discardableResult
  private func makeSection(from flex: Flex) -> Flex {
    flex.addItem().direction(.column).define { flex in
      flex.addItem().direction(.row).marginTop(32).define { flex in
        flex.addFakeView().width(130).height(20)
        flex.addItem().grow(1)
        flex.addFakeView().width(64).height(20)
      }
      flex.addItem().direction(.row).marginTop(24).define { flex in
        makeCell(from: flex)
        makeCell(from: flex).marginLeft(16)
      }
    }
  }
  
  @discardableResult
  private func makeCell(from flex: Flex) -> Flex {
    flex.addItem().direction(.column).alignItems(.start).rowGap(12).define { flex in
      flex.addFakeView().size(148)
      flex.addFakeView().width(148).height(16)
      flex.addFakeView().width(148).height(16)
      flex.addFakeView().width(48).height(24)
    }
  }
}
