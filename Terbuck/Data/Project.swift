import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Data",
    settings: .module,
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Fouryears.Data",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "DomainInterface", path: "../DomainInterface"),
                .project(target: "CoreNetwork", path: "../Core/CoreNetwork"),
                .project(target: "CoreAppleLogin", path: "../Core/CoreAppleLogin"),
                .project(target: "CoreKakaoLogin", path: "../Core/CoreKakaoLogin")
            ]
        )
    ]
)
