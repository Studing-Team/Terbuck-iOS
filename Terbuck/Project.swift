import ProjectDescription

// MARK: - Settings

let projectSettings: Settings = .settings(
    base: [
        "MARKETING_VERSION": "1.0.3",
        "CURRENT_PROJECT_VERSION": "3",
        "DEVELOPMENT_TEAM": "N3H27N59VG",
        "CODE_SIGN_STYLE": "Automatic",
        "OTHER_LDFLAGS": ["-all_load"],
    ],
    configurations: [
        .debug(name: "Debug", xcconfig: .relativeToRoot("Terbuck/Configs/Debug.xcconfig")),
        .release(name: "TestFlight", xcconfig: .relativeToRoot("Terbuck/Configs/TestFlight.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Terbuck/Configs/Release.xcconfig")),
    ]
)

// MARK: - Dependencies

let appDependencies: [TargetDependency] = [
    .external(name: "FirebaseMessaging"),
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
    .project(target: "UniversityInfoFeature", path: "Feature/UniversityInfoFeature"),
    .project(target: "RegisterStudentCardFeature", path: "Feature/RegisterStudentCardFeature"),
]

// MARK: - InfoPlist

let appInfoPlist: [String: Plist.Value] = [
    "LSApplicationCategoryType": "public.app-category.lifestyle",
    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
    "UIDeviceFamily": [1],
    "APP_ID": "6747154359",
    "CFBundleDisplayName": "터벅",
    "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait"
    ],
    "UILaunchScreen": [
        "UIColorName": "",
        "UIImageName": ""
    ],
    "BASE_URL": "$(BASE_URL)",
    "ACCESS_TOKEN_KEY": "$(ACCESS_TOKEN_KEY)",
    "REFRESH_TOKEN_KEY": "$(REFRESH_TOKEN_KEY)",
    "NAVER_MAP_KEY": "$(NAVER_MAP_KEY)",
    "NMFClientId": "$(NMFClientId)",
    "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
    "MIXPANEL_USER_KEY": "$(MIXPANEL_USER_KEY)",
    "NSLocationWhenInUseUsageDescription": "현재 위치를 기반으로 주변 제휴 업체를 보여드리기 위해 위치 정보가 필요합니다.",
    "CFBundleURLTypes": [
        ["CFBundleURLSchemes": ["kakao$(KAKAO_NATIVE_APP_KEY)"]]
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

let project = Project(
    name: "Terbuck",
    organizationName: "Fouryears",
    options: .options(
        defaultKnownRegions: ["Ko"],
        developmentRegion: "Ko",
    ),
    settings: projectSettings,
    targets: [
        .target(
            name: "Terbuck",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: appInfoPlist),
            sources: ["Terbuck/Sources/**"],
            resources: ["Terbuck/Resources/**"],
            entitlements: "Terbuck/Terbuck.entitlements",
            dependencies: appDependencies,
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
    ],
    schemes: [
        makeScheme(name: "Terbuck_Dev", configuration: "Debug"),
        makeScheme(name: "Terbuck_TestFlight", configuration: "TestFlight"),
        makeScheme(name: "Terbuck_Release", configuration: "Release"),
    ]
)

private func makeScheme(name: String, configuration: ConfigurationName) -> Scheme {
    return .scheme(
        name: name,
        shared: true,
        buildAction: .buildAction(targets: [
            .target("Terbuck")
        ]),
        runAction: .runAction(configuration: configuration),
        archiveAction: .archiveAction(configuration: configuration)
    )
}
