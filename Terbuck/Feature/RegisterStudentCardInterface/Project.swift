import ProjectDescription

let project = Project(
    name: "RegisterStudentCardInterface",
    targets: [
        .target(
            name: "RegisterStudentCardInterface",
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
