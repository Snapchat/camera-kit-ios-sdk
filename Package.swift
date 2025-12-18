// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "CameraKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "SCSDKCameraKit", targets: ["SCSDKCameraKit"]),
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
            url: "https://storage.googleapis.com/snap-kit-build/scsdk/camera-kit-ios/releases-spm/1.46.0/SCSDKCameraKit.xcframework.zip",
            checksum: "7449ddf0e212b928c72430b52f29cb08e82b6e0d8581ca29837794815e2d9b3b"
        ),
        .binaryTarget(
            name: "SCSDKCameraKitLoginKitAuth",
            url: "https://storage.googleapis.com/snap-kit-build/scsdk/camera-kit-ios/releases-spm/1.46.0/SCSDKCameraKitLoginKitAuth.xcframework.zip",
            checksum: "da20da4d87b0210d8d0f4a5297af9caa423e17f3dea7f7ec16930cff017aaa52"
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
            url: "https://storage.googleapis.com/snap-kit-build/scsdk/camera-kit-ios/releases-spm/1.46.0/SCSDKCameraKitPushToDeviceExtension.xcframework.zip",
            checksum: "21e88100f2cc0ba4dff9679f226fcd230ff89383cffdb9b7ef2f46e0698c5b06"
        ),
        .target(
            name: "SCSDKCameraKitPushToDeviceExtension_Wrapper",
            dependencies: [
                .target(name: "SCSDKCameraKitPushToDeviceExtension")
            ],
            path: "Sources/CameraKitPushToDeviceExtension_Wrapper"
        ),
                
        .target(name: "SCSDKCameraKitReferenceUI", dependencies: ["SCSDKCameraKit"], path: "Sources/SCSDKCameraKitReferenceUI"),
        .target(name: "SCSDKCameraKitReferenceSwiftUI", dependencies: ["SCSDKCameraKitReferenceUI"], path: "Sources/SCSDKCameraKitReferenceSwiftUI")
    ]
)
