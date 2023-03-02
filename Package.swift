// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "YCarousel",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "YCarousel",
            targets: ["YCarousel"]
	)
    ],
    dependencies: [
        .package(
            url: "https://github.com/yml-org/YCoreUI.git",
            from: "1.4.0"
        )
    ],
    targets: [
        .target(
            name: "YCarousel",
            dependencies: ["YCoreUI"]
        ),
        .testTarget(
            name: "YCarouselTests",
            dependencies: ["YCarousel"]
        )
    ]
)
