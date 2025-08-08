import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "StoreInterface",
    settings: .module,
    targets: [
        .target(
            name: "StoreInterface",
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
