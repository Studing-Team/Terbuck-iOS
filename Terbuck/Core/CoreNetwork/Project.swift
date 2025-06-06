import ProjectDescription

let project = Project(
    name: "CoreNetwork",
    targets: [
        .target(
            name: "CoreNetwork",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.CoreNetwork",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ]
)
