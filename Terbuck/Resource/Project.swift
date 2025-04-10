import ProjectDescription

let project = Project(
    name: "Resource",
    targets: [
        .target(
            name: "Resource",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Resource",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
