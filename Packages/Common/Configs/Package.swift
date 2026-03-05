// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Configs",
    products: [
        .library(
            name: "Configs",
            targets: ["Configs"]
        ),
    ],
    targets: [
        .target(
            name: "Configs"
        ),

    ]
)
