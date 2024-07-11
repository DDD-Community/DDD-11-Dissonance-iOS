//
//  Project.swift
//  DDD-11-Dissonance-iOSManifests
//
//  Created by 한상진 on 2024/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: Project.Layer.presentation.layerName,
    product: .staticFramework,
    settings: .settings(base: .init().swiftCompilationMode(.wholemodule)),
    dependencies: [
        .project(target: Project.Layer.design.layerName, path: .relativeToRoot("Targets/\(Project.Layer.design.layerName)")),
        .project(target: Project.Layer.domain.layerName, path: .relativeToRoot("Targets/\(Project.Layer.domain.layerName)")),
        .external(name: "PinLayout"),
        .external(name: "FlexLayout"),
        .external(name: "RxCocoa"),
        .external(name: "ReactorKit")
    ]
)
