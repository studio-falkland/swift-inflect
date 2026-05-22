// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swift-inflect-benchmarks",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(path: ".."),  // swift-inflect root
        .package(url: "https://github.com/ordo-one/package-benchmark", .upToNextMajor(from: "1.4.0")),
    ],
    targets: [
        .executableTarget(
            name: "InflectBenchmarks",
            dependencies: [
                .product(name: "Inflect", package: "swift-inflect"),
                .product(name: "Benchmark", package: "package-benchmark"),
            ],
            path: "InflectBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
    ]
)
