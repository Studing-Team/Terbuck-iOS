import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "HomeInterface",
    settings: .module,
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
