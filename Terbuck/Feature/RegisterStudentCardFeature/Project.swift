import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "RegisterStudentCardFeature",
    settings: .module,
    targets: [
        .target(
            name: "RegisterStudentCardFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.RegisterStudentCard.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "RegisterStudentCardInterface", path: "../RegisterStudentCardInterface"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "CoreKeyChain", path: "../../Core/CoreKeyChain")
            ]
        )
    ]
)
