<div align="center">
 
![camerakit_icon](https://github.com/user-attachments/assets/036e42d2-c99f-45bc-ac0a-fe2fc462b6eb)

# Camera Kit for iOS

[Home Page](https://developers.snap.com/camera-kit/home) | [Documentation & Guides](https://developers.snap.com/camera-kit/getting-started/what-is-camera-kit) | [Showcase](https://ar.snap.com/camera-kit) | [API Reference](https://kit.snapchat.com/reference/CameraKit/ios/1.37.0/index.html) | [Developer Portal](https://kit.snapchat.com/manage/) | [My Lenses](https://my-lenses.snapchat.com/) | [Discord](https://discord.gg/snapar)
</div>

Camera Kit brings the power of Snap's AR platform to your websites and mobile apps on iOS and Android. It has never been easier to create and deliver scalable, multi-platform AR experiences to meet your customers, wherever they are.

<p align="center">
 <img src="https://github.com/user-attachments/assets/4a6174c1-c6fd-47ff-826e-f48afc067331" width="9%" alt="distort" />
 <img src="https://github.com/user-attachments/assets/b894649a-b80c-4ce3-ac5f-0ead9b6327c6" width="9%" alt="hair_simulation" />
 <img src="https://github.com/user-attachments/assets/afd19a3c-b625-4801-ae40-19588cc597e0" width="9%" alt="try_on" />
 <img src="https://github.com/user-attachments/assets/350fdcec-4f6c-456b-849f-a40f1f0dd1b5" width="9%" alt="3d_hand_tracking" />
 <img src="https://github.com/user-attachments/assets/13384317-9a65-4e30-91ef-7679e5b21ec3" width="9%" alt="wrist_wear_try_on" />
 <img src="https://github.com/user-attachments/assets/24d14f33-c121-43ed-9ff7-5ee0f98bcfb7" width="9%" alt="eye_wear_try_on" />
 <img src="https://github.com/user-attachments/assets/02dc6eb7-6b7b-43e4-8607-4dcce4b93bbd" width="9%" alt="true_size_object" />
 <img src="https://github.com/user-attachments/assets/2fe8618c-d9bc-462b-a85e-34fac7c22421" width="9%" alt="vfx" />
 <img src="https://github.com/user-attachments/assets/3988cc25-e058-490a-aa13-8ecca7f1116b" width="9%" alt="landmarkers" />
</p>

## Features

### AR Capabilities
- Face Effects
- Body / Face / Hand Tracking
- World Tracking
- Background Segmentation
- Location AR
- and [many more](https://developers.snap.com/camera-kit/ar-content/ar-overview) 

### iOS SDK
- Integrate with AVCaptureSession, which allows to maintain full control over session configuration, management, and lifecycle
- Fetch and display your lenses
- Capture media
- Leverage Reference UI modules to quickly build Camera Kit based experiences
- Supports iOS 13.0+

## Integration Steps
1. [Setup](https://developers.snap.com/camera-kit/getting-started/setting-up-accounts) your Camera Kit application using [Developer Portal](https://kit.snapchat.com/manage)
2. [Integrate](https://developers.snap.com/camera-kit/integrate-sdk/mobile/ios) Camera Kit SDK into your iOS application
3. [Create](https://developers.snap.com/camera-kit/ar-content/build-lenses) AR experiences using [Lens Studio](https://ar.snap.com/lens-studio) and manage them using [My Lenses](https://my-lenses.snapchat.com/) site

## Modules

A core module that handles AR experiences:
- `SCSDKCameraKit`

A set of [open-sourced](./Sources), reusable UI components and utilities for easier development of Camera Kit based experiences:
- `SCSDKCameraKitReferenceUI`
- `SCSDKCameraKitReferenceSwiftUI`

Modules required for testing your in-development lenses (see [Push-to-Device](https://developers.snap.com/camera-kit/guides/mobile-customization/in-app-lens-testing)):
- `SCSDKCameraKitBaseExtension`
- `SCSDKCameraKitLoginKitAuth`
- `SCSDKCameraKitPushToDeviceExtension`

## Installation
### [Swift Package Manager](https://github.com/apple/swift-package-manager)
1. In Xcode, select "File" → "Add Package Dependencies…"
2. Enter the repository URL: `https://github.com/Snapchat/camera-kit-ios-sdk.git`
3. Select the version and modules you want to use in your project

### [CocoaPods](https://cocoapods.org/)
If you use CocoaPods to manage your dependencies, simply add the following to your `Podfile`:
```ruby
pod 'SCCameraKit'
```

If you'd like to use the Reference UI:

```ruby
pod 'SCCameraKitReferenceUI'
pod 'SCCameraKitReferenceSwiftUI'
```

### Manual
1. Download the binaries from the [Releases](https://github.com/Snapchat/camera-kit-ios-sdk/releases) section
2. Unzip and add the Camera Kit SDK .xcframework to your Xcode project
3. In your target's "General" settings, add the framework to the "Frameworks, Libraries, and Embedded Content" section

## Usage
You can find a more detailed tutorial [here](https://developers.snap.com/camera-kit/guides/tutorials/mobile-tutorials/building-your-first-ios-camera-kit-app)

### Initializing Camera Kit
Obtain an API token for your Camera Kit application on [Developer Portal](https://kit.snapchat.com/manage)

```swift
import SCSDKCameraKit

let sessionConfig = SessionConfig(apiToken: "<YOUR_API_TOKEN>")
let lensesConfig = LensesConfig(cacheConfig: CacheConfig(lensContentMaxSize: 150*1024*1024))
        
let cameraKit = Session(sessionConfig: sessionConfig, lensesConfig: lensesConfig, errorHandler: self)
```

### Implementing Camera View
```swift
// Configure the camera preview view
let previewView = PreviewView()
previewView.automaticallyConfiguresTouchHandler = true
cameraKit.add(output: previewView)

// Configure the capture session
let captureSession = AVCaptureSession()
let input = AVSessionInput(session: captureSession)
let arInput = ARSessionInput()        
cameraKit.start(input: input, arInput: arInput)

DispatchQueue.global(qos: .background).async {
    input.startRunning()
}
```

### Applying AR Lens
You can find lens group IDs and specific lens IDs on [My Lenses](https://my-lenses.snapchat.com/) site
```swift
// Observe a particular lens
cameraKit.lenses.repository.addObserver(self, specificLensID: "<LENS_ID>", inGroupID: "<LENS_GROUP_ID>")

// Implement LensRepositorySpecificObserver to receive observed Lens object
extension MyViewController: LensRepositorySpecificObserver {
    func repository(_ repository: LensRepository, didUpdate lens: Lens, forGroupID groupID: String) {
        lensQueue.async { [weak self] in
            guard let self = self else { return }

            // Apply a lens, which makes it visible on previewView
            self.cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { success in
                if success {
                    print("\(lens.name ?? "Unnamed") (\(lens.id)) Applied")
                } else {
                    print("Lens failed to apply")
                }
            }
        }
    }
    
    func repository(_ repository: LensRepository, didFailToUpdateLensID lensID: String, forGroupID groupID: String, error: Error?) {
        // Handle errors
    }
}
```

## Samples
We provide several sample apps that demonstrate different approaches to integrating the Camera Kit SDK:
- [CameraKitBasicSample](./Samples/CameraKitBasicSample) implements the bare minimum to show a single lens
- [CameraKitSample](./Samples/CameraKitSample) contains a fully functioning camera capture with lenses and preview flow
- [CameraKitAlternateCarouselSample](./Samples/CameraKitAlternateCarouselSample) demonstrates how to build your own carousel and preview screen

## License
Camera Kit for iOS is available under a custom license. See the [LICENSE](./LICENSE) file for more info.

## Contributing
We welcome contributions to the open-sourced parts of Camera Kit for iOS - Reference UI and Sample Apps. Feel free to open issues and submit PRs.

## Changelog
See [CHANGELOG.md](CHANGELOG.md) for details on each release.
