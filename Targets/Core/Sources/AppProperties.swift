//
//  AppProperties
//  Core
//
//  Created by 한상진 on 2024/07/11.
//

import Foundation

public struct AppProperties {
  
  // MARK: - Properties
  public static var baseURL: String {
    guard let infoDictionary = Bundle.main.infoDictionary,
          let baseURL = infoDictionary["BASE_URL"] as? String else { return .init() }
    return "https://\(baseURL)"
  }
  
  public static var accessToken: String {
    guard let accessTokenData = AuthManager.load(authInfoType: .accessToken) else { return .init() }
    
    return "Bearer \(String(decoding: accessTokenData, as: UTF8.self))"
  }
}
