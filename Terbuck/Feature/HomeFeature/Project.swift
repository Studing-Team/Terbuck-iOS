import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "HomeFeature",
    settings: .module,
    targets: [
        .target(
            name: "HomeFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "GoogleMobileAds"),
                .project(target: "HomeInterface", path: "../HomeInterface"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "NotificationSettingInterface", path: "../NotificationSettingInterface"),
                .project(target: "RegisterStudentCardInterface", path: "../RegisterStudentCardInterface")
            ]
        )
    ]
)
