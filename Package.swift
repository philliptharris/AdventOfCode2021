// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AdventOfCode2021",
    products: [
        .library(name: "AdventOfCode2021", targets: ["AdventOfCode2021"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "AdventOfCode2021", dependencies: []),
        .testTarget(name: "AdventOfCode2021Tests", dependencies: ["AdventOfCode2021"])
    ]
)
