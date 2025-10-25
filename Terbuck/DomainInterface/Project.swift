import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DomainInterface",
    settings: .module,
    targets: [
        .target(
            name: "DomainInterface",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.DomainInterface",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ]
)
