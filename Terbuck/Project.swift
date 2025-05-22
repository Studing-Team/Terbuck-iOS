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
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "NAVER_MAP_KEY": "$(NAVER_MAP_KEY)",
                    "NMFClientId": "$(NMFClientId)",
                    "NSLocationWhenInUseUsageDescription": "현재 위치를 사용하려면 허용해주세요."
                ]
            ),
            sources: ["Terbuck/Sources/**"],
            resources: ["Terbuck/Resources/**"],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "FirebaseMessaging"),
                .external(name: "KakaoSDKCommon"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .project(target: "Resource", path: "Resource"),
                .project(target: "Shared", path: "Shared"),
                .project(target: "DesignSystem", path: "DesignSystem"),
                .project(target: "AuthFeature", path: "Feature/AuthFeature"),
                .project(target: "AuthInterface", path: "Feature/AuthInterface"),
                .project(target: "HomeFeature", path: "Feature/HomeFeature"),
                .project(target: "HomeInterface", path: "Feature/HomeInterface"),
                .project(target: "StoreFeature", path: "Feature/StoreFeature"),
                .project(target: "StoreInterface", path: "Feature/StoreInterface"),
                .project(target: "MypageFeature", path: "Feature/MypageFeature"),
                .project(target: "MypageInterface", path: "Feature/MypageInterface"),
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
