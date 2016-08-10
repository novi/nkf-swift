import PackageDescription

let package = Package(
    name: "nkf-swift",
    targets: [
        Target(name: "NKF", dependencies: ["CNKF"]),
        Target(name: "CNKF"),
    ],
    dependencies: [],
    exclude: ["XCode", "CNKF", "Sources/CNKF/nkf"]    
)
