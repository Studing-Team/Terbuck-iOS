import ProjectDescription

//let infoPlist: [String: Plist.Value] = [
//    "NAVER_MAP_KEY": "$(NAVER_MAP_KEY)",
//    "NAVER_MAP_ClientId": "$(NAVER_MAP_ClientId)",
//    "NSLocationWhenInUseUsageDescription": "현재 위치를 사용하려면 허용해주세요."
//]

let project = Project(
    name: "Terbuck",
    organizationName: "Fouryears",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "9KHXTZ4SZ9"
        ],
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Terbuck/Configs/Debug.xcconfig"))
        ]
    ),
    targets: [
        .target(
            name: "Terbuck",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
//            infoPlist: .extendingDefault(with: infoPlist),
            infoPlist: .extendingDefault(
                with: [
                    "UIDeviceFamily": [1],
                    "CFBundleDisplayName": "터벅",
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleVersion": "1",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "BASE_URL": "$(BASE_URL)",
                    "ACCESS_TOKEN_KEY": "$(ACCESS_TOKEN_KEY)",
                    "REFRESH_TOKEN_KEY": "$(REFRESH_TOKEN_KEY)",
                    "NAVER_MAP_KEY": "$(NAVER_MAP_KEY)",
                    "NMFClientId": "$(NMFClientId)",
                    "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
                    "NSLocationWhenInUseUsageDescription": "현재 위치를 사용하려면 허용해주세요.",
                    "CFBundleURLTypes": [
                        [
                            "CFBundleURLSchemes": [ "kakao$(KAKAO_NATIVE_APP_KEY)" ]
                        ]
                    ],
                    "LSApplicationQueriesSchemes": [
                      "kakaokompassauth",
                      "kakaolink"
                    ],
                    "UIBackgroundModes": [
                        "remote-notification"
                    ],
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": true,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ]
                ]
            ),
            sources: ["Terbuck/Sources/**"],
            resources: ["Terbuck/Resources/**"],
            entitlements: .file(path: "Terbuck/Terbuck.entitlements"),
            dependencies: [
                .external(name: "FirebaseMessaging"),
                .project(target: "Resource", path: "Resource"),
                .project(target: "Shared", path: "Shared"),
                .project(target: "DesignSystem", path: "DesignSystem"),
                .project(target: "SplashFeature", path: "Feature/SplashFeature"),
                .project(target: "SplashInterface", path: "Feature/SplashInterface"),
                .project(target: "AuthFeature", path: "Feature/AuthFeature"),
                .project(target: "AuthInterface", path: "Feature/AuthInterface"),
                .project(target: "HomeFeature", path: "Feature/HomeFeature"),
                .project(target: "HomeInterface", path: "Feature/HomeInterface"),
                .project(target: "StoreFeature", path: "Feature/StoreFeature"),
                .project(target: "StoreInterface", path: "Feature/StoreInterface"),
                .project(target: "MypageFeature", path: "Feature/MypageFeature"),
            ]
        ),
        .target(
            name: "TerbuckTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.Fouryears.Terbuck",
            infoPlist: .default,
            sources: ["Terbuck/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Terbuck")]
        ),
    ]
)
