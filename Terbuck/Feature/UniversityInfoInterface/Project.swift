import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "UniversityInfoInterface",
    settings: .module,
    targets: [
        .target(
            name: "UniversityInfoInterface",
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
