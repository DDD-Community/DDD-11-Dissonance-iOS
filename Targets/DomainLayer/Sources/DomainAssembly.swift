//
//  DomainAssembly.swift
//  DomainLayer
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DIContainer

public struct DomainAssembly: DependencyAssemblable {
  
  // MARK: - Initializer
  public init() {}
  
  // MARK: - Methods
  public func assemble(container: DIContainer) {
    container.register(type: LoginUseCaseType.self) { container in
      return LoginUseCase(loginRepository: container.resolve(type: LoginRepositoryType.self)!)
    }
    
    container.register(type: PostUploadUseCaseType.self) { container in
      return PostUploadUseCase(postRepository: container.resolve(type: PostRepositoryType.self)!)
    }
    
    container.register(type: FetchPostListUseCaseType.self) { container in
      return FetchPostListUseCase(postRepository: container.resolve(type: PostRepositoryType.self)!)
    }
    
    container.register(type: SearchPostListUseCaseType.self) { container in
      return SearchPostListUseCase(postRepository: container.resolve(type: PostRepositoryType.self)!)
    }
    
    container.register(type: FetchBannerUseCaseType.self) { container in
      return FetchBannerUseCase(postRepository: container.resolve(type: PostRepositoryType.self)!)
    }
    
    container.register(type: UpdateBannerUseCaseType.self) { container in
      return UpdateBannerUseCase(postRepository: container.resolve(type: PostRepositoryType.self)!)
    }
    
    container.register(type: PostDetailUseCaseType.self) { container in
      return PostDetailUseCase(postRepository: container.resolve(type: PostRepositoryType.self)!)
    }
    
    container.register(type: UserUseCaseType.self) { container in
      return UserUseCase(userRepository: container.resolve(type: UserRepositoryType.self)!)
    }
    
    container.register(type: MyPageUseCaseType.self) { container in
      return MyPageUseCase(userRepository: container.resolve(type: UserRepositoryType.self)!)
    }
    
    container.register(type: BookmarkToggleUseCaseType.self) { container in
      return BookmarkToggleUseCase(bookmarkRepository: container.resolve(type: BookmarkRepositoryType.self)!)
    }
    
    container.register(type: FetchBookmarkListUseCaseType.self) { container in
      return FetchBookmarkListUseCase(bookmarkRepository: container.resolve(type: BookmarkRepositoryType.self)!)
    }
  }
}
