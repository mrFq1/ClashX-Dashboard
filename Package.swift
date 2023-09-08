// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClashX Dashboard",
	platforms: [
		.macOS(.v12),
	],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "ClashX Dashboard",
			targets: ["ClashX Dashboard"]),
	],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
		 .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
		 .package(url: "https://github.com/daltoniam/Starscream.git", exact: "3.1.1"),
		 .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.0.0"),
		 .package(url: "https://github.com/dagronf/DSFSparkline.git", from: "4.0.0"),
		 .package(url: "https://github.com/siteline/swiftui-introspect", from: "0.10.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ClashX Dashboard",
            dependencies: [
				"Alamofire",
				"CocoaLumberjack",
				.product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
				"DSFSparkline",
				.product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
				"Starscream",
				"SwiftyJSON",
				
			]),
        .testTarget(
            name: "ClashX Dashboard Tests",
            dependencies: ["ClashX Dashboard"]),
    ]
)
