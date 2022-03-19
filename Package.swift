// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHUD",
    products: [
        .library(
            name: "SwiftHUD",
            targets: ["SwiftHUD"]),
    ],
    targets: [
        .target(
            name: "SwiftHUD",
            dependencies: []),
    ]
)
