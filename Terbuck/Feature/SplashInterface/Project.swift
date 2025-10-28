import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "SplashInterface",
    settings: .module,
    targets: [
        .target(
            name: "SplashInterface",
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
