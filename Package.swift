// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPMGen",
    dependencies: [
        .package(url: "https://github.com/marcuswu0814/SwiftCLIToolbox", .branch("master"))
    ],
    targets: [
        .target(
            name: "SwiftPMGen",
            dependencies: ["SwiftPMGenCore"]),
        .testTarget(
            name: "SwiftPMGenTests",
            dependencies: ["SwiftPMGen"]),
        .target(
            name: "SwiftPMGenCore",
            dependencies: ["SwiftCLIToolbox"]),
        .testTarget(
            name: "SwiftPMGenCoreTests",
            dependencies: ["SwiftPMGenCore"]),
    ]
)
