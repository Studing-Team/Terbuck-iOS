import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "NotificationSettingFeature",
    settings: .module,
    targets: [
        .target(
            name: "NotificationSettingFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.NotificationSetting.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .project(target: "NotificationSettingInterface", path: "../NotificationSettingInterface"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
            ]
        )
    ]
)
