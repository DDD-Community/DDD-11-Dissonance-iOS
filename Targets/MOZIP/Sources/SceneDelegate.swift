//
//  SceneDelegate.swift
//  DDD-11-Dissonance-iOSManifests
//
//  Created by 한상진 on 2024/07/11.
//

import DIContainer
import DataLayer
import DomainLayer
import PresentationLayer
import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Properties
  var window: UIWindow?
  private var mainCoordinator: MainCoordinatorType?
  private var navigationController: UINavigationController?
  
  // MARK: - Methods
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    
    
    let navigationController: UINavigationController = .init(nibName: nil, bundle: nil)
    self.navigationController = navigationController
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    assemble()
    self.mainCoordinator = MainCoordinator(navigationController: navigationController)
    mainCoordinator?.start()
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      if (AuthApi.isKakaoTalkLoginUrl(url)) {
        _ = AuthController.handleOpenUrl(url: url)
      }
    }
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}

// MARK: - Private Extenion
private extension SceneDelegate {
  func assemble() {
    guard let navigationController = navigationController else {
      return
    }
    
    let container: DIContainer = .shared
    DataAssembly().assemble(container: container)
    DomainAssembly().assemble(container: container)
    PresentationAssembly(navigationController: navigationController).assemble(container: container)
  }
}
