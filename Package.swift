import PackageDescription

let package = Package(
    name: "nkf-swift",
    dependencies: [],
    exclude: ["XCode", "CNKF", "Sources/CNKF/nkf"],
    targets: [
        Target(name: "NKF", dependencies: ["CNKF"]),
        Target(name: "CNKF"),
    ]
)
