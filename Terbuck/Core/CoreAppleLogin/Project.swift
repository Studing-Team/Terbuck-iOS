import ProjectDescription

let project = Project(
    name: "CoreAppleLogin",
    targets: [
        .target(
            name: "CoreAppleLogin",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.CoreAppleLogin",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ]
)
