import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "NotificationSettingInterface",
    settings: .module,
    targets: [
        .target(
            name: "NotificationSettingInterface",
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
