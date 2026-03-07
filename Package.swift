// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TMDbApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "TMDbCore", targets: ["TMDbCore"])
    ],
    targets: [
        .target(
            name: "TMDbCore",
            path: "TMDbApp/Core"
        ),
        .testTarget(
            name: "TMDbCoreTests",
            dependencies: ["TMDbCore"],
            path: "Tests/TMDbCoreTests"
        )
    ]
)
