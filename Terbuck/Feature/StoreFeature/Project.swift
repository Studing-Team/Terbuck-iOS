import ProjectDescription

let project = Project(
    name: "StoreFeature",
    targets: [
        .target(
            name: "StoreFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.Terbuck",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "NMapsMap"),
                .project(target: "StoreInterface", path: "../StoreInterface"),
                .project(target: "DesignSystem", path: "../../DesignSystem")
            ]
        )
    ]
)
