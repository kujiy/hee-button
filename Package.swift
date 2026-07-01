// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "hee-button",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(
            name: "hee-button",
            path: "Sources/hee-button",
            // Resources are copied straight into the assembled app's
            // Contents/Resources by Scripts/build-app.sh and loaded via
            // Bundle.main — not via SwiftPM's Bundle.module (which resolves
            // relative to the executable's dir and breaks once relocated
            // into a .app). Excluded here so SwiftPM ignores them.
            exclude: ["Resources"]
        )
    ]
)
