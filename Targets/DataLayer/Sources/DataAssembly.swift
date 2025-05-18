//
//  DataAssembly.swift
//  DataLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer
import DomainLayer

public struct DataAssembly: DependencyAssemblable {

  // MARK: - Initializer
  public init() {}

  // MARK: - Methods
  public func assemble(container: DIContainer) {
    container.register(type: LoginRepositoryType.self) { _ in LoginRepository() }
    container.register(type: PostRepositoryType.self) { _ in PostRepository() }
    container.register(type: UserRepositoryType.self) { _ in UserRepository() }
    container.register(type: BookmarkRepositoryType.self) { _ in BookmarkRepository() }
  }
}
