//
//  PresentationAssembly.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer
import UIKit


public struct PresentationAssembly: DependencyAssemblable {
  
  // MARK: - Properties
  private let navigationController: UINavigationController
  
  // MARK: - Initializer
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  public func assemble(container: DIContainer) {
    container.register(type: LoginCoordinatorType.self) { _ in
      LoginCoordinator(navigationController: navigationController)
    }
  }
}
