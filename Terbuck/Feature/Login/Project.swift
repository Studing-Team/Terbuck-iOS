import ProjectDescription

let project = Project(
    name: "Login",
    targets: [
        .target(
            name: "Login",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Fouryears.login",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Resource", path: "../../Resource"),
                .project(target: "Shared", path: "../../Shared")
            ]
        )
    ]
)
