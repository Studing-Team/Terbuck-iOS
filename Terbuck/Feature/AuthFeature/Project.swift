import ProjectDescription

let project = Project(
    name: "AuthFeature",
    targets: [
        .target(
            name: "AuthFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .project(target: "AuthInterface", path: "../AuthInterface"),
                .project(target: "UniversityInfoFeature", path: "../UniversityInfoFeature"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "CoreKeyChain", path: "../../Core/CoreKeyChain"),
                .project(target: "CoreKakaoLogin", path: "../../Core/CoreKakaoLogin"),
                .project(target: "CoreAppleLogin", path: "../../Core/CoreAppleLogin")
            ]
        )
    ]
)
