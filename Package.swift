// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GoRSS",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "GoRSSCore", targets: ["GoRSSCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/nmdias/FeedKit", from: "9.1.2")
    ],
    targets: [
        .target(
            name: "GoRSSCore",
            dependencies: [
                .product(name: "FeedKit", package: "FeedKit")
            ],
            path: "GoRSS",
            exclude: [
                "GoRSSApp.swift", 
                "ContentView.swift", 
                "AddFeedView.swift", 
                "SafariView.swift"
            ],
            sources: [
                "RSSItem.swift", 
                "RSSService.swift", 
                "FeedViewModel.swift", 
                "FeedSource.swift"
            ]
        )
    ]
)