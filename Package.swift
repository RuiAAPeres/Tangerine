// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Tangerine",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Tangerine",
            targets: ["Tangerine"]),
    ],
    targets: [
        .target(
            name: "Tangerine",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "TangerineTests",
            dependencies: ["Tangerine"]),
    ],
    swiftLanguageVersions: [
        .version("5.1")
    ]
)
