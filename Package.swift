// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftOCRKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftOCRKit",
            targets: ["SwiftOCRKit"]
        )
    ],
    targets: [
        .target(
            name: "SwiftOCRKit",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftOCRKitTests",
            dependencies: ["SwiftOCRKit"]
        )
    ]
)

