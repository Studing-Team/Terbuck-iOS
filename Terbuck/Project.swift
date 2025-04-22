import ProjectDescription

let project = Project(
    name: "Terbuck",
    organizationName: "Fouryears",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "9KHXTZ4SZ9"
        ]
    ),
    targets: [
        .target(
            name: "Terbuck",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
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
