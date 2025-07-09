import ProjectDescription

let project = Project(
    name: "RegisterStudentCardFeature",
    targets: [
        .target(
            name: "RegisterStudentCardFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.RegisterStudentCard.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "CoreKeyChain", path: "../../Core/CoreKeyChain")
            ]
        )
    ]
)
