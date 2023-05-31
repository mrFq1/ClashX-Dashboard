// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClashX Dashboard Kit",
	platforms: [
		.macOS(.v12),
	],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "ClashX Dashboard Kit",
			targets: ["ClashX Dashboard Kit"]),
	],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
		 .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
		 .package(url: "https://github.com/daltoniam/Starscream.git", exact: "3.1.1"),
		 .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.0.0"),
		 .package(url: "https://github.com/ra1028/DifferenceKit.git", from: "1.0.0"),
		 .package(url: "https://github.com/dagronf/DSFSparkline.git", from: "4.0.0"),
		 .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.2.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ClashX Dashboard Kit",
            dependencies: [
				"Alamofire",
				"CocoaLumberjack",
				.product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
				"DifferenceKit",
				"DSFSparkline",
				.product(name: "Introspect", package: "SwiftUI-Introspect"),
				"Starscream",
				"SwiftyJSON",
				
			]),
        .testTarget(
            name: "ClashX Dashboard KitTests",
            dependencies: ["ClashX Dashboard Kit"]),
    ]
)
