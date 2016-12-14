import PackageDescription

let package = Package(
    name: "NKF",
    targets: [
        Target(name: "NKF", dependencies: ["CNKF"]),
        Target(name: "CNKF"),
    ],
    dependencies: [],
    exclude: ["XCode", "CNKF", "Sources/CNKF/nkf"]    
)
