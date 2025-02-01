// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCStringsGenPlugin",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .plugin(name: "XCStringsGenPlugin", targets: ["XCStringsGenPlugin"]),
        .executable(name: "XCStringsGen", targets: ["XCStringsGen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.1")
    ],
    targets: [
        .plugin(
            name: "XCStringsGenPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "XCStringsGen")
            ]
        ),
        .executableTarget(
            name: "XCStringsGen",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        ),
    ]
)
