// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        )
    ],
    dependencies: [
        .package(path: "../../Common/Models")
    ],
    targets: [
        .target(
            name: "Navigation",
            dependencies: ["Models"]
        )
    ]
)
