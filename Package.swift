// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BusyBox",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "BusyBox",
            path: "BusyBox"
        )
    ]
)
