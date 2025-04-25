// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .framework,
            "Moya": .framework,
            "Then": .framework,
            "Pulse": .framework,
            "KakaoOpenSDK": .framework,
            "Swinject": .framework
        ],
        baseSettings: Settings.settings(configurations: XCConfig.framework)
    )
#endif

let package = Package(
    name: "TestProject",
    platforms: [.iOS(.v16)],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.17.1"),
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.3"),
        .package(url: "https://github.com/devxoul/Then.git", exact: "3.0.0"),
        .package(url: "https://github.com/kean/Pulse.git", exact: "5.1.2"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.17.1"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.23.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.9.1"),
    ]
)
