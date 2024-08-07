//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 한상진 on 2024/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: Project.Layer.design.layerName,
    product: .staticFramework,
    settings: .settings(base: .init().swiftCompilationMode(.wholemodule)),
    dependencies: [
        .project(target: Project.Layer.domain.layerName, path: .relativeToRoot("Targets/\(Project.Layer.domain.layerName)")),
        .external(name: "RxCocoa"),
        .external(name: "RxSwift"),
        .external(name: "PinLayout"),
        .external(name: "FlexLayout")
    ],
    resources: ["Resources/**"]
)
