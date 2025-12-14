// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NewmanFantasyFootball",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "NewmanFantasyFootball",
            targets: ["NewmanFantasyFootball"]),
    ],
    targets: [
        .target(
            name: "NewmanFantasyFootball",
            path: "NewmanFantasyFootball",
            exclude: ["Assets.xcassets", "NewmanFantasyFootball.xcodeproj"],
            sources: [
                "ContentView.swift",
                "Views.swift",
                "ExtendedFeatures.swift",
                "RivalsAndNavigation.swift",
                "SocialFeatures.swift",
                "CommunityHub.swift"
            ]
        )
    ]
)
