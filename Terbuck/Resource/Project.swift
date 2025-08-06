import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Resource",
    settings: .module,
    targets: [
        .target(
            name: "Resource",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.Resource",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
