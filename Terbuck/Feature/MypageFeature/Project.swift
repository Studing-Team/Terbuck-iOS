import ProjectDescription

let project = Project(
    name: "MypageFeature",
    targets: [
        .target(
            name: "MypageFeature",
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
                .project(target: "MypageInterface", path: "../MypageInterface"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "UniversityInfoFeature", path: "../UniversityInfoFeature"),
                .project(target: "NotificationSettingFeature", path: "../NotificationSettingFeature"),
                .project(target: "RegisterStudentCardFeature", path: "../RegisterStudentCardFeature")
            ]
        )
    ]
)
