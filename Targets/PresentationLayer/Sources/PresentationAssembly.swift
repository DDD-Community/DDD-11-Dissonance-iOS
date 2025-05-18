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
    
    container.register(type: PostUploadCoordinatorType.self) { _ in
      PostUploadCoordinator(navigationController: navigationController)
    }
    
    container.register(type: PostRecommendCoordinatorType.self) { _ in
      PostRecommendCoordinator(navigationController: navigationController)
    }
    
    container.register(type: PostDetailCoordinatorType.self) { _ in
      PostDetailCoordinator(navigationController: navigationController)
    }
    
    container.register(type: HomeCoordinatorType.self) { _ in
      HomeCoordinator(navigationController: navigationController)
    }
    
    container.register(type: PostListCoordinatorType.self) { _ in
      PostListCoordinator(navigationController: navigationController)
    }
    
    container.register(type: PostSearchCoordinatorType.self) { _ in
      PostSearchCoordinator(navigationController: navigationController)
    }

    container.register(type: MyPageCoordinatorType.self.self) { _ in
      MyPageCoordinator(navigationController: navigationController)
    }
    
    container.register(type: TermsPolicyCoordinatorType.self) { _ in
      TermsPolicyCoordinator(navigationController: navigationController)
    }
    
    container.register(type: BookmarkListCoordinatorType.self) { _ in
      BookmarkListCoordinator(navigationController: navigationController)
    }
  }
}
