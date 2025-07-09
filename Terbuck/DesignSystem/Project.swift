import ProjectDescription

let project = Project(
    name: "DesignSystem",
    targets: [
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.DesignSystem.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .project(target: "CoreNetwork", path: "../Core/CoreNetwork"),
                .project(target: "CoreKeyChain", path: "../Core/CoreKeyChain"),
                .project(target: "Resource", path: "../Resource"),
                .project(target: "Shared", path: "../Shared")
            ]
        )
    ]
)
