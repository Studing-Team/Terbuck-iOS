import ProjectDescription

public extension Settings {
    private static let defaultConfigurations: [Configuration] = [
        .debug(name: "Debug"),
        .release(name: "TestFlight"),
        .release(name: "Release")
    ]
    
    static let module: Settings = .settings(configurations: defaultConfigurations)
}
