import ProjectDescription

let project = Project(
    name: "UniversityInfoFeature",
    targets: [
        .target(
            name: "UniversityInfoFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "CoreKeyChain", path: "../../Core/CoreKeyChain")
            ]
        )
    ]
)
