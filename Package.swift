import PackageDescription

let package = Package(
    name: "NKF",
    dependencies: [
                      .Package(url: "https://github.com/novi/CNKF.git", majorVersion: 0)
                      ]
)
