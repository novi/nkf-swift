import PackageDescription

let package = Package(
    name: "NKF",
    targets: [
        Target(name: "NKF", dependencies: ["CNKF"]),
        Target(name: "CNKF"),
    ],
    dependencies: [],
    exclude: ["Xcode", "CNKF", "Sources/CNKF/nkf"]    
)
