// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "CameraKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "SCSDKCameraKit", targets: ["SCSDKCameraKit"]),
        .library(name: "SCSDKCameraKitBaseExtension", targets: ["SCSDKCameraKitBaseExtension_Wrapper"]),
        .library(name: "SCSDKCameraKitLoginKitAuth", targets: ["SCSDKCameraKitLoginKitAuth_Wrapper"]),
        .library(name: "SCSDKCameraKitPushToDeviceExtension", targets: ["SCSDKCameraKitPushToDeviceExtension_Wrapper"]),
        .library(name: "SCSDKCameraKitReferenceUI", targets: ["SCSDKCameraKitReferenceUI"]),
        .library(name: "SCSDKCameraKitReferenceSwiftUI", targets: ["SCSDKCameraKitReferenceSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Snapchat/snap-kit-spm", .upToNextMajor(from: "2.5.0"))
    ],
    targets: [
        .binaryTarget(
            name: "SCSDKCameraKit",
            url: "https://storage.googleapis.com/snap-kit-build/scsdk/camera-kit-ios/releases-spm/1.38.0/SCSDKCameraKit.xcframework.zip",
            checksum: "aeabb3a4179ac059ebfba0eb43e43149f63821dc1240aca5d7aaba7d71ce7a1b"
        ),
        
        .binaryTarget(
            name: "SCSDKCameraKitBaseExtension",
            url: "https://storage.googleapis.com/snap-kit-build/scsdk/camera-kit-ios/releases-spm/1.38.0/SCSDKCameraKitBaseExtension.xcframework.zip",
            checksum: "b25c6f720ebaf0a14a72e511a594366754e60f4ed71ef4ad9ef2910d32e2682d"
        ),
        .target(
            name: "SCSDKCameraKitBaseExtension_Wrapper",
            dependencies: [
                .target(name: "SCSDKCameraKitBaseExtension"),
                .target(name: "SCSDKCameraKit")
            ],
            path: "Sources/CameraKitBaseExtension_Wrapper"
        ),

        .binaryTarget(
            name: "SCSDKCameraKitLoginKitAuth",
            url: "https://storage.googleapis.com/snap-kit-build/scsdk/camera-kit-ios/releases-spm/1.38.0/SCSDKCameraKitLoginKitAuth.xcframework.zip",
            checksum: "6a2cf1638924b8916e16d1c993b841b0803d80a507011a726097d49779603da8"
        ),
        .target(
            name: "SCSDKCameraKitLoginKitAuth_Wrapper",
            dependencies: [
                .target(name: "SCSDKCameraKitLoginKitAuth"),
                .target(name: "SCSDKCameraKit"),
                .product(name: "SnapSDK", package: "snap-kit-spm")
            ],
            path: "Sources/CameraKitLoginKitAuth_Wrapper"
        ),

        .binaryTarget(
            name: "SCSDKCameraKitPushToDeviceExtension",
            url: "https://storage.googleapis.com/snap-kit-build/scsdk/camera-kit-ios/releases-spm/1.38.0/SCSDKCameraKitPushToDeviceExtension.xcframework.zip",
            checksum: "c691cb804ef0eb4c277b4d13a4e156439e010b05e958a0349da52c34a18f25b7"
        ),
        .target(
            name: "SCSDKCameraKitPushToDeviceExtension_Wrapper",
            dependencies: [
                .target(name: "SCSDKCameraKitPushToDeviceExtension"),
                .target(name: "SCSDKCameraKitBaseExtension_Wrapper"),
            ],
            path: "Sources/CameraKitPushToDeviceExtension_Wrapper"
        ),
                
        .target(name: "SCSDKCameraKitReferenceUI", dependencies: ["SCSDKCameraKit"], path: "Sources/SCSDKCameraKitReferenceUI"),
        .target(name: "SCSDKCameraKitReferenceSwiftUI", dependencies: ["SCSDKCameraKitReferenceUI"], path: "Sources/SCSDKCameraKitReferenceSwiftUI")
    ]
)
