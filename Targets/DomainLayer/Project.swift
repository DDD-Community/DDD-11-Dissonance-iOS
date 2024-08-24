//
//  Project.swift
//  DDD-11-Dissonance-iOSManifests
//
//  Created by 한상진 on 2024/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: Project.Layer.domain.layerName,
    product: .staticFramework,
    settings: .settings(base: .init().swiftCompilationMode(.wholemodule)),
    dependencies: [
        .project(target: Project.Layer.core.layerName, path: .relativeToRoot("Targets/\(Project.Layer.core.layerName)")),
        .project(target: Project.Layer.dependencyInjector.layerName, path: .relativeToRoot("Targets/\(Project.Layer.dependencyInjector.layerName)")),
        .external(name: "RxDataSources")
    ]
)
