import ProjectDescription

public let defaultConfigurations: [Configuration] = [
    .debug(name: "Debug"),
    .release(name: "TestFlight"),
    .release(name: "Release"),
]

public extension Settings {
    static let module: Settings = .settings(configurations: defaultConfigurations)
}
