// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoodExtensions",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GoodExtensions",
            targets: ["GoodExtensions"]
        ),
        .library(
            name: "GoodStructs",
            targets: ["GoodStructs"]
        ),
        .library(
            name: "GoodCombineExtensions",
            targets: ["GoodCombineExtensions"]
        ),
        .library(
            name: "GoodCache",
            targets: ["GoodCache"]
        ),
        .library(
            name: "GoodReactor",
            targets: ["GoodReactor"]
        ),
        .library(
            name: "GoodRequestManager",
            targets: ["GoodRequestManager"]
        ),
        .library(
            name: "Mockable",
            targets: ["Mockable"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GRCompatible",
            dependencies: []
        ),
        .target(
            name: "GoodExtensions",
            dependencies: [.target(name: "GRCompatible")]
        ),
        .target(
            name: "GoodCombineExtensions",
            dependencies: ["CombineExt", .target(name: "GRCompatible")]
        ),
        .target(
            name: "GoodStructs",
            dependencies: [],
            path: "./Sources/GoodStructs"
        ),
        .target(
            name: "GoodReactor",
            dependencies: ["CombineExt"],
            path: "./Sources/GoodReactor"
        ),
        .target(
            name: "GoodCache",
            dependencies: [.target(name: "GRCompatible"), "CombineExt"],
            path: "./Sources/GoodCache"
        ),
        .target(
            name: "GoodRequestManager",
            dependencies: ["Alamofire", .target(name: "GoodStructs"), .target(name: "GRCompatible")],
            path: "./Sources/GoodRequestManager"
        ),
        .target(
            name: "Mockable",
            dependencies: ["GoodRequestManager"],
            path: "./Sources/Mockable"
        ),
        .testTarget(
            name: "GoodExtensionsTests",
            dependencies: ["GoodExtensions", "Mockable", "GoodRequestManager"],
            resources:
            [
                .copy("Resources/EmptyElement.json"),
                .copy("Resources/ArrayNil.json")
            ]
        ),
        .testTarget(
            name: "GoodCacheTests",
            dependencies: ["GoodCache"]
        ),
        .testTarget(
            name: "GoodCombineExtensionsTests",
            dependencies: ["GoodCombineExtensions"]
        ),
        .testTarget(
            name: "GoodCompatibleTests",
            dependencies: ["GRCompatible"]
        ),
        .testTarget(
            name: "GoodReactorTests",
            dependencies: ["GoodReactor"]
        ),
        .testTarget(
            name: "GoodRequestManagerTests",
            dependencies: ["GoodRequestManager"]
        ),
        .testTarget(
            name: "GoodStructsTests",
            dependencies: ["GoodStructs"]
        )
    ]
)
