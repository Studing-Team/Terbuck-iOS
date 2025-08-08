import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "CoreKeyChain",
    settings: .module,
    targets: [
        .target(
            name: "CoreKeyChain",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.CoreKeyChain",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Shared", path: "../../Shared"),
            ]
        )
    ]
)
