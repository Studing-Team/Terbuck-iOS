import ProjectDescription

let project = Project(
    name: "HomeInterface",
    targets: [
        .target(
            name: "HomeInterface",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Shared", path: "../../Shared")
            ]
        )
    ]
)
