// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPMGen",
    dependencies: [
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
            dependencies: []),
        .testTarget(
            name: "SwiftPMGenCoreTests",
            dependencies: ["SwiftPMGenCore"]),
    ]
)
