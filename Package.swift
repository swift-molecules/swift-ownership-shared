// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-ownership-shared",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Ownership Shared Primitive", targets: ["Ownership Shared Primitive"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-ring.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-storage-generational.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-hash-table.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-hash.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-heap.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-span.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ownership.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Ownership Shared Primitive",
            dependencies: [
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(
                    name: "Buffer Ring Bounded Primitive",
                    package: "swift-buffer-ring"
                ),
                .product(
                    name: "Storage Generational",
                    package: "swift-storage-generational"
                ),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Hash", package: "swift-hash"),
                .product(name: "Store Primitive", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Ownership Box", package: "swift-ownership"),
                .product(name: "Ownership Primitive", package: "swift-ownership"),
            ]
        ),

        .testTarget(
            name: "Shared Tests",
            dependencies: [
                "Ownership Shared Primitive",
                .product(name: "Buffer Linear", package: "swift-buffer-linear"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(
                    name: "Buffer Ring Bounded Primitive",
                    package: "swift-buffer-ring"
                ),
                .product(
                    name: "Buffer Test Support",
                    package: "swift-buffer"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("BuiltinModule"),
        .enableExperimentalFeature("RawLayout"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
