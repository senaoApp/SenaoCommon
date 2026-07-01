// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SenaoCommon",
    // 設定支援的平台，建議跟您的主 App 最低版本一致 (例如 iOS 13)
    platforms: [
        .iOS(.v13)
    ],
    // 定義這個 Package 提供什麼產品 (Library)
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SenaoCommon",
            targets: ["SenaoCommon"]
        ),
    ],
    // 定義依賴 (原本 Podfile 裡的項目移到這裡)
    dependencies: [
        // Podfile: pod 'RxSwift', '6.2.0' & pod 'RxCocoa', '6.2.0'
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.2.0")),
        // Podfile: pod 'Alamofire' (SPM 建議指定版本，這裡假設用 5.x)
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0"))
    ],
    // 定義 Target 與連結依賴
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SenaoCommon",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "Alamofire", package: "Alamofire")
            ],
            // 指定原始碼路徑
            // 預設 SPM 會找 Sources/SenaoCommon，若結構不同，需用 path 指定
            path: "Sources/SenaoCommon"
        ),
        .testTarget(
            name: "SenaoCommonTests",
            dependencies: ["SenaoCommon"]
        ),
    ]
)
