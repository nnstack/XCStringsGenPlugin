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
        .plugin(name: "XCStringsGenPlugin", targets: ["XCStringsGenPlugin"])
    ],
    targets: [
        .plugin(
            name: "XCStringsGenPlugin",
            capability: .buildTool(),
            dependencies: [],
            path: "Sources/"
        )
    ]
)
