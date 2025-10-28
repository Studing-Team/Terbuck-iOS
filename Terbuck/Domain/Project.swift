import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Domain",
    settings: .module,
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.Domain",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "DomainInterface", path: "../DomainInterface"),
                .project(target: "Data", path: "../Data")
            ]
        )
    ]
)
