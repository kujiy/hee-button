// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "hee-button",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(
            name: "hee-button",
            path: "Sources/hee-button",
            resources: [.process("Resources")]
        )
    ]
)
