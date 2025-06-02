//
//  Project.swift
//  DDD-11-Dissonance-iOSManifests
//
//  Created by 한상진 on 2024/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers
import Foundation

// Fastlane에서 전달된 환경 변수

enum Const {
  static let buildNumber = "5"
}

private var infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.2.3",
    "CFBundleVersion": "\(Const.buildNumber)",
    "CFBundleIconName": "AppIcon",
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
    "NSPhotoLibraryUsageDescription": "공고를 대표할 이미지를 선택하기 위해 사진첩에 접근합니다.",
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
    name: "MOZIP",
    product: .app,
    settings: .settings(
        base: [
          "CODE_SIGN_STYLE": "Manual",
          "DEVELOPMENT_TEAM": "SWPBG3YXG5"
        ],
        configurations: [
            .debug(
                name: "Debug",
                settings: [
                    "PROVISIONING_PROFILE_SPECIFIER": "match Development run.ddd.MOZIP",
                    "CODE_SIGN_IDENTITY": "Apple Development"
                ],
                xcconfig: .relativeToCurrentFile("Config/Debug.xcconfig")
            ),
            .release(
                name: "Release",
                settings: [
                    "PROVISIONING_PROFILE_SPECIFIER": "match AppStore run.ddd.MOZIP",
                    "CODE_SIGN_IDENTITY": "Apple Distribution"
                ],
                xcconfig: .relativeToCurrentFile("Config/Release.xcconfig")
            )
        ]
    ),
    dependencies: [
        .project(target: Project.Layer.presentation.layerName, path: .relativeToRoot("Targets/\(Project.Layer.presentation.layerName)")),
        .project(target: Project.Layer.data.layerName, path: .relativeToRoot("Targets/\(Project.Layer.data.layerName)"))
    ],
    resources: ["Resources/**"],
    entitlements: .file(path: "MOZIP.entitlements"),
    infoPlist: .extendingDefault(with: infoPlist)
)
