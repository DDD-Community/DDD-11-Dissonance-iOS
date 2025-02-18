//
//  LoadingIndicator.swift
//  DesignSystem
//
//  Created by 이원빈 on 2/18/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import UIKit

public class LoadingIndicator {
  
  public static func start(withDimming dimming: Bool = false) {
    DispatchQueue.main.async {
      let window: UIWindow = UIApplication.topWindow
      let loadingIndicatorView: UIActivityIndicatorView
      
      if let existedView = window.subviews.first(
        where: { $0 is UIActivityIndicatorView }
      ) as? UIActivityIndicatorView {
        loadingIndicatorView = existedView
      } else {
        loadingIndicatorView = UIActivityIndicatorView(style: .medium)
        loadingIndicatorView.frame = window.frame
        loadingIndicatorView.color = dimming ? .white : .gray
        loadingIndicatorView.backgroundColor = dimming ? .black.withAlphaComponent(0.7) : nil
        loadingIndicatorView.alpha = 0
        window.addSubview(loadingIndicatorView)
        UIView.animate(withDuration: 0.2) {
          loadingIndicatorView.alpha = 1
        }
      }
      
      loadingIndicatorView.startAnimating()
    }
  }
  
  public static func stop() {
    DispatchQueue.main.async {
      UIApplication.topWindow.subviews
        .filter { $0 is UIActivityIndicatorView }
        .forEach { activityIndication in
          UIView.animate(withDuration: 0.2) {
            activityIndication.alpha = 0
          } completion: { _ in
            activityIndication.removeFromSuperview()
          }
        }
    }
  }
}
