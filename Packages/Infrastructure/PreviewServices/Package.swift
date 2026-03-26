// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PreviewServices",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PreviewServices",
            targets: ["PreviewServices"]
        )
    ],
    dependencies: [
        .package(path: "../../Common/Models"),
        .package(path: "../Services"),
        .package(path: "../../Common/Configs")
    ],
    targets: [
        .target(
            name: "PreviewServices",
            dependencies: ["Models", "Services", "Configs"],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
