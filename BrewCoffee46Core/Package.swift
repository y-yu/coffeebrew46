// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "BrewCoffee46Core",
    platforms: [.iOS(.v16), .watchOS(.v10)],
    products: [
        .library(name: "BrewCoffee46Core", targets: ["BrewCoffee46Core"]),
        .library(name: "BrewCoffee46TestsShared", targets: ["BrewCoffee46TestsShared"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BrewCoffee46TestsShared",
            dependencies: [
                "BrewCoffee46Core"
            ]
        ),
        .target(
            name: "BrewCoffee46Core",
            dependencies: []
        ),
        .testTarget(
            name: "BrewCoffee46CoreTests",
            dependencies: [
                "BrewCoffee46Core",
                "BrewCoffee46TestsShared",
            ]
        ),
    ]
)
