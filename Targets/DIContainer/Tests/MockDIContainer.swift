//
//  MockDIContainer.swift
//  DIContainerTests
//
//  Created by 한상진 on 2024/07/27.
//  Copyright © 2024 MOZIP. All rights reserved.
//

@testable import DIContainer

final class MockDIContainer: DIContainable {
    private var services: [String: DependencyFactoryClosure] = [:]
    
    func register<Service>(type: Service.Type, factoryClosure: @escaping DependencyFactoryClosure) {
        services["\(type)"] = factoryClosure
    }

    func resolve<Service>(type: Service.Type) -> Service? {
        return services["\(type)"]?(self) as? Service
    }
}
