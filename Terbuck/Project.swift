import ProjectDescription

let project = Project(
    name: "Terbuck",
    targets: [
        .target(
            name: "Terbuck",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Terbuck",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Terbuck/Sources/**"],
            resources: ["Terbuck/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "TerbuckTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.TerbuckTests",
            infoPlist: .default,
            sources: ["Terbuck/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Terbuck")]
        ),
    ]
)
