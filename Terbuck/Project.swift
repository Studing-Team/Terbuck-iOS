import ProjectDescription

let settings: Settings = .settings(
    base: [
        "DEVELOPMENT_TEAM": "N3H27N59VG",
        "CODE_SIGN_STYLE": "Automatic",
        "OTHER_LDFLAGS": ["-all_load"]
    ],
    configurations: [
        .debug(name: "Debug", xcconfig: .relativeToRoot("Terbuck/Configs/Debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Terbuck/Configs/Release.xcconfig"))
    ]
)

let project = Project(
    name: "Terbuck",
    organizationName: "Fouryears",
    settings: settings,
    targets: [
        .target(
            name: "Terbuck",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
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
                    "MIXPANEL_USER_KEY": "$(MIXPANEL_USER_KEY)",
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
                        "UIApplicationSupportsMultipleScenes": false,
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
            entitlements: "Terbuck/Terbuck.entitlements",
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
                .project(target: "NotificationSettingInterface", path: "Feature/NotificationSettingInterface"),
                .project(target: "NotificationSettingFeature", path: "Feature/NotificationSettingFeature"),
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
