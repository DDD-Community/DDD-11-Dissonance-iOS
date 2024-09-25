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
  
  public static var refreshToken: String {
    guard let refreshTokenData = AuthManager.load(authInfoType: .refreshToken) else { return .init() }
    return String(decoding: refreshTokenData, as: UTF8.self)
  }
  
  public static var isAdmin: Bool {
    guard let adminData = AuthManager.load(authInfoType: .isAdmin) else { return .init() }
    return "true" == String(decoding: adminData, as: UTF8.self)
  }
  
  public static var provider: String {
    guard let providerData = AuthManager.load(authInfoType: .provider) else { return .init() }
    return String(decoding: providerData, as: UTF8.self)
  }
  
  public static var questionURLString: String {
    return "https://forms.gle/2ioTW82MZW8cQQf96"
  }
  
  public static var privacyPolicyURLString: String {
    return "https://mozip-cx.notion.site/10aad2225910808d9226e7ac52fcb4c7"
  }
  
  public static var termsOfUseURLString: String {
    return "https://mozip-cx.notion.site/e66935e610364c41bd8bbd7019e303ad"
  }
}
