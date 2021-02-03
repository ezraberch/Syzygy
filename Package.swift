// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Syzygy",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Syzygy",
            targets: ["Syzygy"]),
        .library(
            name: "SyzygyServer",
            targets: ["SyzygyServer"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/krzysztofzablocki/Sourcery.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Syzygy",
            dependencies: []),
        .target(
            name: "SyzygyServer",
            dependencies: [.product(name: "Vapor", package: "vapor"),.product(name: "sourcery", package: "Sourcery")],
            resources: [.copy("ServerTemplate.swifttemplate")]),
        .testTarget(
            name: "SyzygyTests",
            dependencies: [.target(name: "Syzygy")]),
        .testTarget(
            name: "SyzygyServerTests",
            dependencies: [.target(name: "SyzygyServer"), .product(name: "XCTVapor", package: "vapor")]),
    ]
)
