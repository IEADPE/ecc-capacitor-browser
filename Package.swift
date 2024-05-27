// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EccCapacitorBrowser",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "EccCapacitorBrowser",
            targets: ["EccCapacitorBrowserPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "EccCapacitorBrowserPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/EccCapacitorBrowserPlugin"),
        .testTarget(
            name: "EccCapacitorBrowserPluginTests",
            dependencies: ["EccCapacitorBrowserPlugin"],
            path: "ios/Tests/EccCapacitorBrowserPluginTests")
    ]
)
