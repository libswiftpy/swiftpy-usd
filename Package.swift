// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swiftpy-usd",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(
            name: "SwiftPyUSD",
            targets: [
                "SwiftPyUSD",
                "Gf",
                "Sdf",
                "Usd",
                "UsdGeom",
                "UsdMedia",
                "UsdSkel",
                "UsdUtils",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/felfoldy/SwiftPy", from: "0.17.0"),
        .package(url: "https://github.com/apple/SwiftUsd", from: "5.2.0"),
    ],
    targets: [
        .target(
            name: "pxr",
            dependencies: [
                .product(
                    name: "OpenUSD",
                    package: "SwiftUsd"
                )
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),

        .target(
            name: "Sdf",
            dependencies: [
                "pxr",
                "SwiftPy",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),

        .target(
            name: "Gf",
            dependencies: [
                "pxr",
                "SwiftPy",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),

        .target(
            name: "Usd",
            dependencies: [
                "pxr",
                "SwiftPy",
                "Sdf",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
        
        .target(
            name: "UsdGeom",
            dependencies: [
                "pxr",
                "Usd",
                "Sdf",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),

        .target(
            name: "UsdMedia",
            dependencies: [
                "pxr",
                "SwiftPy",
                "Usd",
                "Sdf",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),

        .target(
            name: "UsdSkel",
            dependencies: [
                "pxr",
                "SwiftPy",
                "Usd",
                "Sdf",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),

        .target(
            name: "UsdUtils",
            dependencies: [
                "pxr",
                "SwiftPy",
                "Sdf",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),

        .target(
            name: "SwiftPyUSD",
            dependencies: [
                "SwiftPy",
                "Gf",
                "Sdf",
                "Usd",
                "UsdGeom",
                "UsdMedia",
                "UsdSkel",
                "UsdUtils",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),

        .testTarget(
            name: "SwiftPyUSDTests",
            dependencies: ["SwiftPyUSD"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ],
    cxxLanguageStandard: .gnucxx17
)
