//
//  Project.swift
//  DDD-11-Dissonance-iOSManifests
//
//  Created by 한상진 on 2024/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "CFBundleDisplayName": "$(PRODUCT_NAME)",
    "UILaunchStoryboardName": "LaunchScreen",
    "UIUserInterfaceStyle": "Light",
    "CFBundleURLTypes": [
        [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": ["kakao${KAKAO_NATIVE_APP_KEY}"]
        ]
    ],
    "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}",
    "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink"],
    "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
    "NSPhotoLibraryAddUsageDescription": "사진첩 접근 권한 요청",
    "UIApplicationSupportsIndirectInputEvents": true,
    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": true,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ],
            ]
        ]
    ],
    "LSSupportsOpeningDocumentsInPlace": true,
    "BASE_URL": "${BASE_URL}",
    "USER_AGENT": "${USER_AGENT}"
]

let project = Project.makeProject(
    name: "ITIT",
    product: .app,
    settings: .settings(
        base: .init().swiftCompilationMode(.wholemodule).automaticCodeSigning(devTeam: "SWPBG3YXG5"),
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToCurrentFile("Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToCurrentFile("Config/Release.xcconfig"))
        ]
    ),
    dependencies: [
        .project(target: Project.Layer.presentation.layerName, path: .relativeToRoot("Targets/\(Project.Layer.presentation.layerName)")),
        .project(target: Project.Layer.data.layerName, path: .relativeToRoot("Targets/\(Project.Layer.data.layerName)"))
    ],
    resources: ["Resources/**"],
    infoPlist: .extendingDefault(with: infoPlist)
)
