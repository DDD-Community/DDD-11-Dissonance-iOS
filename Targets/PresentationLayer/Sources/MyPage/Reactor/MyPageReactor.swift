//
//  MyPageReactor.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/30.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DomainLayer

import ReactorKit

final class MyPageReactor: Reactor {
  
  // MARK: - Properties
  private let useCase: MyPageUseCaseType
  var initialState: State = .init()
  
  enum TableViewSections {
    case profile, services
    
    var headerTitle: String {
      switch self {
      case .profile: "내 정보"
      case .services: "서비스 지원"
      }
    }
    
    var itemsTitle: [String] {
      switch self {
      case .profile: ["연결된 계정"]
      case .services: ["문의사항", "약관 및 정책", "버전 정보", "로그아웃", "탈퇴하기"]
      }
    }
  }
  
  enum Action {
    case didTapLogoutButton
    case didTapDeleteAccountButton
  }
  
  enum Mutation {
    case setLogoutState(Bool)
  }
  
  struct State {
    var isLoggedOut: Bool = false
  }
  
  // MARK: - Initializer
  init(useCase: MyPageUseCaseType) {
    self.useCase = useCase
  }
  
  // MARK: - Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapLogoutButton:        return .just(.setLogoutState(true))
    case .didTapDeleteAccountButton: return .just(.setLogoutState(true))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setLogoutState(let isLoggedOut):
      newState.isLoggedOut = isLoggedOut
    }
    
    return newState
  }
}
