import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "CoreNetwork",
    settings: .module,
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
            dependencies: [
                .project(target: "CoreKeyChain", path: "../CoreKeyChain"),
                .project(target: "Shared", path: "../../Shared"),
            ]
        )
    ]
)
