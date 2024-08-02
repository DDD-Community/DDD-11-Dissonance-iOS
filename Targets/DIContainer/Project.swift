//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 한상진 on 2024/07/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: Project.Layer.dependencyInjector.layerName,
    product: .staticFramework,
    settings: .settings(base: .init().swiftCompilationMode(.wholemodule)),
    dependencies: [
    ]
)
