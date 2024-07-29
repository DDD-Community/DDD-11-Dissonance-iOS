//
//  MozipToast.swift
//  DesignSystem
//
//  Created by 이원빈 on 2024/07/29.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

import PinLayout

public final class MozipToast: UIView {
    
    private enum Metric {
        static let height: CGFloat = 56
        static let horizontalMargin: CGFloat = 20
        static let cornerRadius: CGFloat = 8
    }
    
    // MARK: - UI
    private let messageLabel = MozipLabel(style: .toast_ToastMessage)
    
    // MARK: - Initializers
    public init() {
        super.init(frame: .zero)
        setupViewHierarchy()
        setupInitialSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    public func setMessage(_ message: String) {
        messageLabel.updateTextKeepingAttributes(message)
    }
}

// MARK: - Layout Settings

private extension MozipToast {
    func setupViewHierarchy() {
        self.addSubview(messageLabel)
    }
    
    func setupConstraints() {
        pin.height(Metric.height).horizontally().margin(Metric.horizontalMargin)
        messageLabel.pin.all()
    }
    
    func setupInitialSettings() {
        messageLabel.textAlignment = .center
        self.layer.cornerRadius = Metric.cornerRadius
        backgroundColor = .mozipColor.gray800
    }
}
