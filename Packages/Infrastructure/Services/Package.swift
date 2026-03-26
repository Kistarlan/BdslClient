// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]
        )
    ],
    dependencies: [
        .package(path: "../../Common/Models"),
        .package(path: "../../Common/Configs"),
        .package(path: "../MongoFilters")
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: ["Models", "Configs", "MongoFilters"]
        )
    ]
)
