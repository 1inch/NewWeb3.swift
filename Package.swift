// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "Web3",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "Web3",
            targets: ["Web3"]),
        .library(
            name: "Web3ContractABI",
            targets: ["Web3ContractABI"]),
    ],
    dependencies: [
        // Core dependencies
        .package(url: "https://github.com/attaswift/BigInt.git", exact: "5.3.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.8.2"),
        .package(url: "https://github.com/1inch/secp256k1.swift", from: "0.2.2"),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/vapor/websocket-kit", .upToNextMajor(from: "2.15.0")),

        // Test dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.1"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.18.1"),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.6.7"),
    ],
    targets: [
        .target(
            name: "Web3",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "secp256k1", package: "secp256k1.swift"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "WebSocketKit", package: "websocket-kit"),
            ],
            path: "Sources",
            sources: ["Core", "FoundationHTTP"]),
        .target(
            name: "Web3ContractABI",
            dependencies: [
                .target(name: "Web3"),
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
            ],
            path: "Sources",
            sources: ["ContractABI"]),
        .testTarget(
            name: "Web3Tests",
            dependencies: [
                .target(name: "Web3"),
                .target(name: "Web3ContractABI"),
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble"),
                .product(name: "PromiseKit", package: "PromiseKit"),
                .product(name: "AnyCodable", package: "AnyCodable"),
            ],
            resources: [
                .copy("ABITests/solidity-hashes.json"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
