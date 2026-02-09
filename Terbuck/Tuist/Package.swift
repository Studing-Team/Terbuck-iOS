// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        baseSettings: .settings(
            configurations: [
                .debug(name: "Debug"),
                .release(name: "TestFlight"),
                .release(name: "Release"),
            ]
        )
        // Customize the product types for specific package product
        // Default is .staticFramework
    )
#endif

let package = Package(
    name: "TuistDependencies",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
        .package(url: "https://github.com/navermaps/SPM-NMapsMap", from: "3.12.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.24.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.21.0"),
        .package(url: "https://github.com/mixpanel/mixpanel-swift", from: "2.10.4"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.0.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "10.0.0")
    ]
)
