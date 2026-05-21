// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swift-inflect",
    products: [
        .library(name: "Inflect", targets: ["Inflect"]),
    ],
    targets: [
        .target(
            name: "Inflect",
            path: "Sources/Inflect"
        ),
        .testTarget(
            name: "InflectTests",
            dependencies: ["Inflect"],
            path: "Tests/InflectTests"
        ),
    ]
)
