// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "NKF",
    products: [
        .library(name: "NKF", targets: ["NKF"])
    ],
    targets: [
        .target(name: "NKF", dependencies: ["CNKF"]),
        .target(name: "CNKF"),
        .testTarget(name: "NKFTests", dependencies: ["NKF"])
    ]
)
