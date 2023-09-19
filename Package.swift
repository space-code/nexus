// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nexus",
    platforms: [
        .iOS(.v13),
        .watchOS(.v7),
    ],
    products: [.library(name: "Nexus", targets: ["Nexus"])],
    dependencies: [],
    targets: [
        .target(name: "Nexus", dependencies: []),
        .testTarget(name: "NexusTests", dependencies: ["Nexus"]),
    ]
)
