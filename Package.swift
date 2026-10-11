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
        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-store.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-buffer.git",
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
            url: "https://github.com/swift-molecules/swift-hash-table.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-storage.git",
            branch: "main", traits: ["Generational", "Memory"]),
        .package(
            url: "https://github.com/swift-atoms/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main", traits: ["MemorySmall", "MemoryAllocatorArena", "MemoryInline"]),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-span.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ownership.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-carrier.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-property.git", branch: "main"),
    ],
    targets: [

        .target(
            name: "Ownership Shared Primitive",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(
                    name: "Affine",
                    package: "swift-affine"
                ),
                .product(name: "Buffer", package: "swift-buffer"),
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
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Hash Table Primitive", package: "swift-hash-table"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Memory", package: "swift-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Pool",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Ordinal",
                    package: "swift-ordinal"
                ),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Memory Small", package: "swift-memory-allocation"),
            ]
        ),

        .testTarget(
            name: "Shared Tests",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),

                .target(name: "Ownership Shared Primitive"),
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
                .product(name: "Buffer", package: "swift-buffer"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Pool",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Property", package: "swift-property"),
            ]
        ),

        .testTarget(name: "Ownership Shared Decision Column Integration Tests", dependencies: [.target(name: "Ownership Shared Primitive"), .product(name: "Buffer Linear", package: "swift-buffer-linear"), .product(name: "Buffer", package: "swift-buffer"), .product(name: "Storage", package: "swift-storage"), .product(name: "Memory Allocator", package: "swift-memory-allocation"), .product(name: "Memory", package: "swift-memory"), .product(name: "Index", package: "swift-index"), .product(name: "Tagged", package: "swift-tagged"), .product(name: "Cardinal", package: "swift-cardinal")], path: "Tests/Ownership Shared Decision Column Integration Tests"),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
