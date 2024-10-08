// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HPOpenWeather",
    platforms: [
        .iOS(.v15), .tvOS(.v15), .watchOS(.v6), .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "HPOpenWeather",
            targets: ["HPOpenWeather"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/henrik-dmg/HPNetwork", from: "4.0.0"),
        .package(url: "https://github.com/henrik-dmg/HPURLBuilder", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "HPOpenWeather",
            dependencies: [
                .product(name: "HPNetworkMock", package: "HPNetwork"),
                "HPURLBuilder",
            ]
        ),
        .testTarget(
            name: "HPOpenWeatherTests",
            dependencies: [
                "HPOpenWeather",
                .product(name: "HPNetworkMock", package: "HPNetwork"),
            ],
            resources: [.process("Resources")]
        ),
    ]
)
