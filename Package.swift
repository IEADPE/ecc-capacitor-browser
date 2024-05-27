// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IeadpeCapacitorBrowser",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "IeadpeCapacitorBrowser",
            targets: ["IeadpeCapacitorBrowserPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "IeadpeCapacitorBrowserPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/IeadpeCapacitorBrowserPlugin"),
        .testTarget(
            name: "IeadpeCapacitorBrowserPluginTests",
            dependencies: ["IeadpeCapacitorBrowserPlugin"],
            path: "ios/Tests/IeadpeCapacitorBrowserPluginTests")
    ]
)
