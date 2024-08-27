//
//  Project+Templates.swift
//  DDD-11-Dissonance-iOSManifests
//
//  Created by 한상진 on 2024/07/11.
//

import ProjectDescription

public extension Project {
    enum Layer: CaseIterable {
        case dependencyInjector
        case core
        case design
        case domain
        case data
        case presentation
        
        public var layerName: String {
            switch self {
            case .dependencyInjector: return "DIContainer"
            case .core: return "Core"
            case .design: return "DesignSystem"
            case .domain: return "DomainLayer"
            case .data: return "DataLayer"
            case .presentation: return "PresentationLayer"
            }
        }
    }
    
    static func makeProject(
        name: String,
        product: Product,
        settings: Settings,
        deploymentTarget: DeploymentTargets = .iOS("15.0"),
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        infoPlist: InfoPlist = .default
    ) -> Project {
        let app: Target = .target(
            name: name,
            destinations: .iOS,
            product: product,
            bundleId: "run.ddd.\(name)",
            deploymentTargets: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: entitlements,
            dependencies: dependencies
        )

        let test: Target = .target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "run.ddd.\(name)Tests",
            deploymentTargets: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: name)]
        )

        let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]

        let targets: [Target] = [app, test]

        return Project(
            name: name,
            organizationName: "MOZIP",
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
