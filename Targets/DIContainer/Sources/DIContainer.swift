public typealias DependencyFactoryClosure = (DIContainable) -> Any

public protocol DependencyAssemblable {
  func assemble(container: DIContainer)
}

public protocol DIContainable {
  func register<Service>(type: Service.Type, factoryClosure: @escaping DependencyFactoryClosure)
  func resolve<Service>(type: Service.Type) -> Service?
}

public final class DIContainer: DIContainable {

  // MARK: - Properties
  public static let shared: DIContainer = .init()
  var services: [String: DependencyFactoryClosure] = [:]

  // MARK: - Initializer
  private init() {}

  // MARK: - Methods
  public func register<Service>(type: Service.Type, factoryClosure: @escaping DependencyFactoryClosure) {
    services["\(type)"] = factoryClosure
  }

  public func resolve<Service>(type: Service.Type) -> Service? {
    let service = services["\(type)"]?(self) as? Service

    if service == nil {
      print("❌ \(#file) - \(#line): \(#function) - Fail: \(type) resolve Error")
      print(services)
    }

    return service
  }
}
