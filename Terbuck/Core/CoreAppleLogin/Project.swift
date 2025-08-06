import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "CoreAppleLogin",
    settings: .module,
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
            dependencies: [
                .project(target: "Shared", path: "../../Shared"),
            ]
        )
    ]
)
