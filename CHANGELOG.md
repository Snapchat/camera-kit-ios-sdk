# CHANGELOG

All notable changes to the Camera Kit SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and the Camera Kit SDK adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<a name="unreleased"></a>
## [Unreleased]

<a name="1.37.0"></a>
## [1.37.0] - 2024-12-18
### Features
- Lens Studio 5.4 support
- Support for Lens HTTP requests

<a name="1.36.1"></a>
## [1.36.1] - 2024-11-22
### Bug Fixes
- Fix for Lens Studio 5.3 support

<a name="1.36.0"></a>
## [1.36.0] - 2024-11-14
### Features
- Lens Studio 5.3 support

### Updates
- Launched a dedicated iOS repository: https://github.com/Snapchat/camera-kit-ios-sdk, now supporting Swift Package Manager

<a name="1.35.0"></a>
## [1.35.0] - 2024-10-16
### Features
- Lens Studio 5.2 support

<a name="1.34.0"></a>
## [1.34.0] - 2024-09-17
### Features
- Lens Studio 5.1 support

### Updates
- Fix an issue with Custom Location Markers
- Fix an issue caused by the NS_OPTIONS not being supported in Objc++

<a name="1.33.0"></a>
## [1.33.0] - 2024-08-21
### Features
- Lens Studio 5.0.19 support

<a name="1.32.0"></a>
## [1.32.0] - 2024-07-24
### Features
- Lens Studio 5.0.17 support

### Updates
- Improvement for microphone permission handling that could cause video freeze

<a name="1.31.0"></a>
## [1.31.0] - 2024-06-12
### Features
- Lens Studio 5.0.14 support

### Updates
- Updated [Privacy manifest file](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files) describing data the SDK collects and reasons required APIs it uses.

<a name="1.30.0"></a>
## [1.30.0] - 2024-04-24
### Features
- Lens Studio 5.0.10 support
- Added [Privacy manifest file](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files) describing data the SDK collects and reasons required APIs it uses.

### Updates
- Added new `SCCameraKitPushToDeviceProtocol#unpair` method to unpair from Push-to-Device.

<a name="1.29.0"></a>
## [1.29.0] - 2024-03-20
- Fix for a blank preview on app launch when device is in a low bandwidth environment

<a name="1.28.0"></a>
## [1.28.0] - 2024-02-08
<a name="1.27.0"></a>
## [1.27.0] - 2023-12-13
### Features
- Lens Studio 5.0.2 support

<a name="1.26.2"></a>
## [1.26.2] - 2023-11-13
- Fix face detection for 3+ faces on IOS front camera.
- Update CocoaPods's pod names to SCCameraKit, SCCameraKitReferenceUI, SCCameraKitReferenceSwiftUI, SCCameraKitLoginKitAuth, SCCameraKitBaseExtension, SCCameraKitConnectedLensesExtension, SCCameraKitPushToDeviceExtension from this release on. Framework names in code remain the same.

<a name="1.26.1"></a>
## [1.26.1] - 2023-10-12
### Bug Fixes
- Lens elements that use overlay render target may be get incorrectly positioned when camera input does not match preview output aspect ratio
<a name="1.26.0"></a>
## [1.26.0] - 2023-09-13 - _LTS_
### Features
- Lens Studio 4.55 support

### Bug Fixes
- Wrong camera orientation after device rotation on iOS 16 and later

### Known Issues
- Lens UI elements assinged to the overlay render target can get incorrectly positioned when device camera input frame does not match preview preview frame aspect ratio

<a name="1.25.0"></a>
## [1.25.0] - 2023-08-15
### Features
- Lens Studio 4.53 support

<a name="1.24.0"></a>
## [1.24.0] - 2023-06-27
### Features
- Lens Studio 4.49 support
### Updates
- Add a debug dialog to swap API token for testing
- Add support for configuring debug dialogs via deep links/qr codes.
### Bug Fixes
- Fix a bug where certain assets could be loaded later than expected, potentially causing the lens to fail to load entirely if device was offline.

<a name="1.23.0"></a>
## [1.23.0] - 2023-05-17
### Features
- Lens Studio 4.47 support
### Bug Fixes
- Fix share button working as save button in the reference UI

<a name="1.22.0"></a>
## [1.22.0] - 2023-05-08
### Updates
- Deprecate application ID, remove its use across sample apps
### Features
- Lens Studio 4.46 support

### Bug Fixes
- Fix a bug in the reference UI where tapping share button leads to a crash on iPad

<a name="1.21.1"></a>
## [1.21.1] - 2023-03-29
### Bug Fixes
- Fixed issue where photos of certain lenses could output a blank image
- Fixed issue where touch handling could be processed incorrectly

<a name="1.21.0"></a>
## [1.21.0] - 2023-03-24
### Features
- Lens Studio 4.43 support

<a name="1.20.0"></a>
## [1.20.0] - 2023-02-21
### Features
- Lens Studio 4.40 support
### Bug Fixes
- Fixed bug where login flow could fail during Push to Device configuration
- Fix Snap attribution view is not shown outside of US

<a name="1.19.2"></a>
## [1.19.2] - 2023-01-12
### Bug Fixes
- Fix the issue of staging watermark showing with production API token

<a name="1.19.1"></a>
## [1.19.1] - 2023-01-09
<a name="1.19.0"></a>
## [1.19.0] - 2022-12-28
### Features
- Lens Studio 4.36 support
- Add a new sample app that demonstrates a custom implementation of lenses carousel and camera preview layout
- Add a debug menu to the sample app to customize lens groups at runtime

<a name="1.18.1"></a>
## [1.18.1] - 2022-11-30
<a name="1.18.0"></a>
## [1.18.0] - 2022-11-21
### Features
- Lens Studio 4.34 support
- [Custom Location AR](https://docs.snap.com/lens-studio/references/templates/landmarker/custom-landmarker) (Beta feature) support

### Updates
- Snap attribition support as per [Design Guidelines](https://docs.snap.com/snap-kit/camera-kit/release/design-guide)
- Staging Watermark applies on staging builds of Camera Kit integrations
- Xcode 14 or above required
- Discontinued support on iOS 11 and lower
<a name="1.17.1"></a>
## [1.17.1] - 2022-11-30
<a name="1.17.0"></a>
## [1.17.0] - 2022-10-12
### Features
- Lens Studio 4.31 support
- Add support for City-Scale AR Lenses (Beta)
- Add support for Push-to-Device (P2D) feature (Beta), which allows developers to send Lenses from Lens Studio to their Camera Kit application for testing. Note that on Android, P2D is only supported if your application uses the built-in lenses carousel.
<a name="1.16.0"></a>
## [1.16.0] - 2022-09-09
### Features
- Lens Studio 4.28.x support
- Add support for Connected Lenses (Closed Beta)
- Add support for arm64 simulators

<a name="1.15.1"></a>
## [1.15.1] - 2022-07-20
<a name="1.15.0"></a>
## [1.15.0] - 2022-07-18
### Notes
- This version has critical issues on Android. Use version 1.15.1 instead

### Features
- Lens Studio 4.25 support
<a name="1.14.1"></a>
## [1.14.1] - 2022-06-30
<a name="1.14.0"></a>
## [1.14.0] - 2022-06-27
### Notes
- This version has critical issues on Android. Use version 1.14.1 instead

### Features
- Lens Studio 4.22 support
- Add support for lenses with static assets
- Add standard flash along with ring light for front-facing flash to sample app

<a name="1.13.0"></a>
## [1.13.0] - 2022-05-27
### Features
- New API to support lenses which use the remote service [feature](https://docs.snap.com/lens-studio/references/guides/lens-features/remote-apis/remote-service-module)
- New tone-mapping and portrait camera adjustments
- Add explicit viewport configuration to SCCameraKitPreviewView

<a name="1.12.0"></a>
## [1.12.0] - 2022-04-22
### Notes
- Starting with this release, an API token **must** be provided as part of the Camera Kit configuration, failure to do so will result in a runtime exception. See [Android](https://docs.snap.com/snap-kit/camera-kit/configuration/android#service-authorization) and [iOS](https://docs.snap.com/snap-kit/camera-kit/configuration/ios/#service-authorization) documentation for examples on how to obtain and provide an API token.
- The legal agreement prompt has been updated to use a more user friendly text copy. Updating to this release will result in users needing to accept the updated prompt which includes a new link to the Camera Kit&#39;s "learn more" [page](https://support.snapchat.com/en-US/article/camera-information-use).

### Features
- Lens Studio 4.19 support
### Bug Fixes
- `LensProcessor.setAudioMuted` doesn't mute/unmute audio coming from lenses

### Known Issues
- Lenses using the new [Text to Speech](https://docs.snap.com/lens-studio/references/guides/lens-features/audio/text-to-speech) feature throw a runtime exception on Android and simply do nothing on iOS. This is expected as the feature is currently unavailable in Camera Kit.

<a name="1.11.1"></a>
## [1.11.1] - 2022-04-05
### Bug Fixes
- Fix bug where landmarkers would not work properly

<a name="1.11.0"></a>
## [1.11.0] - 2022-03-14
### Bug Fixes
- Allow recording videos up to 60 seconds by default

### Features
- Add support for text input in lenses
- Lens Studio 4.16 support

<a name="1.10.0"></a>
## [1.10.0] - 2022-02-28
### Bug Fixes
- Binary size optimizations (1.3MB uncompressed savings)
### Features
- :  Added missing "Privacy - Location When In Use Usage Description" entry in Sample App Info.plist
<a name="1.9.2"></a>
## [1.9.2] - 2022-02-10
<a name="1.9.1"></a>
## [1.9.1] - 2022-01-26
### Bug Fixes
- Fixed bug where `additionalConfigurationFlags` would not be processed correctly

<a name="1.9.0"></a>
## [1.9.0] - 2022-01-18
### Features
- Lens Studio 4.13 support
- M1/arm64 simulator support
- Add support for tap to focus

### Bug Fixes
- Audio cuts out when swapping camera

<a name="1.8.4"></a>
## [1.8.4] - 2022-01-14
### Bug Fixes
- SessionConfig values not being used correctly

<a name="1.8.3"></a>
## [1.8.3] - 2022-01-12
### Bug Fixes
- Clear out queue file if it is corrupted

### Features
- Expose legal agreement URLs

<a name="1.8.2"></a>
## [1.8.2] - 2021-12-15
### Bug Fixes
-  Missing localized strings
<a name="1.8.1"></a>
## [1.8.1] - 2021-12-09
### Bug Fixes
-  Too-large images fail to load in media picker
-  Lens content downloads use non-optimal CDN links
- unknown_lens_hint blinks on activation
- Rear camera not using LiDAR for depth when supported

<a name="1.8.0"></a>
## [1.8.0] - 2021-12-07
### Bug Fixes
- Touch targets in lenses are not aligned with actual elements
- Recording keeps going past duration but animation stops
- Memory leak when device is offline
- gRPC objective c runtime conflicts
- Rebuilt deliverable with latest toolset to prevent crashes

### Features
- Support API token based authorization
- Legal agreement prompt pop-up dialog support

<a name="1.7.6"></a>
## [1.7.6] - 2021-11-08
### Bug Fixes
-  Extension API mismatch

<a name="1.7.5"></a>
## [1.7.5] - 2021-10-28
### Bug Fixes
- Memory leak when device is offline
- Potential gRPC objective c runtime conflicts when host app contains gRPC
- Surface tracking behaves incorrectly in portrait mode

### Features
-  Lens Studio 4.7 support

<a name="1.7.4"></a>
## [1.7.4] - 2021-10-20
<a name="1.7.3"></a>
## [1.7.3] - 2021-10-11
### Bug Fixes
- Cache size config being ignored

<a name="1.7.2"></a>
## [1.7.2] - 2021-10-07
### Bug Fixes
- Remove private API usage

<a name="1.7.1"></a>
## [1.7.1] - 2021-10-01
### Bug Fixes
- Borders on captured images and videos
- Process images at video resolution

<a name="1.7.0"></a>
## [1.7.0] - 2021-09-22
### Bug Fixes
- Deadlock on stopping session
- Process images at video resolution (scaling was causing layers of lens to disappear or objects to move their location in photos)

### Features
- SwiftUI support
- Added SRE metrics

<a name="1.6.21"></a>
## [1.6.21] - 2021-10-11
### Bug Fixes
- Cache size config being ignored

<a name="1.6.20"></a>
## [1.6.20] - 2021-10-07
### Bug Fixes
- Remove private API usage

<a name="1.6.19"></a>
## [1.6.19] - 2021-10-01
### Bug Fixes
- Borders on captured images and videos

<a name="1.6.18"></a>
## [1.6.18] - 2021-09-29
### Bug Fixes
-  Landmarkers localisation issues

<a name="1.6.17"></a>
## [1.6.17] - 2021-09-22
<a name="1.6.16"></a>
## [1.6.16] - 2021-09-20
### Bug Fixes
- Button hit target may not have aligned with rendered UI

<a name="1.6.15"></a>
## [1.6.15] - 2021-09-14
### Features
-  LensStudio 4.5 support

<a name="1.6.14"></a>
## [1.6.14] - 2021-09-03
### Bug Fixes
-  Stability issues

<a name="1.6.13"></a>
## [1.6.13] - 2021-09-02
### Features
- Bitcode support

<a name="1.6.12"></a>
## [1.6.12] - 2021-08-17
<a name="1.6.11"></a>
## [1.6.11] - 2021-08-06
<a name="1.6.10"></a>
## [1.6.10] - 2021-07-23
<a name="1.6.9"></a>
## [1.6.9] - 2021-07-19
### Bug Fixes
- Localization always giving priority to preferred languages with 3 letter ISO 639-2 codes

<a name="1.6.8"></a>
## [1.6.8] - 2021-07-13
<a name="1.6.7"></a>
## [1.6.7] - 2021-07-08
### Bug Fixes
- Increase max lenses content size
- Some lenses turn grayscale when recording

<a name="1.6.6"></a>
## [1.6.6] - 2021-06-22
### Bug Fixes
- Large photo picker images (panorama) exceed memory

<a name="1.6.5"></a>
## [1.6.5] - 2021-06-17
<a name="1.6.4"></a>
## [1.6.4] - 2021-06-16
### Bug Fixes
- Previous lens would sometimes be applied after new one was applied

<a name="1.6.3"></a>
## [1.6.3] - 2021-06-16
<a name="1.6.1"></a>
## [1.6.1] - 2021-05-10
### Bug Fixes
- Deadlock on stopping session

<a name="1.6.0"></a>
## [1.6.0] - 2021-04-26
### Features
- Landmarkers support
- Media picker support

<a name="1.5.11"></a>
## [1.5.11] - 2021-03-17

<a name="1.5.10"></a>
## [1.5.10] - 2021-03-03
<a name="1.5.9"></a>
## [1.5.9] - 2021-02-26

<a name="1.5.8"></a>
## [1.5.8] - 2021-02-24
<a name="1.5.7"></a>
## [1.5.7] - 2021-02-18
<a name="1.5.6"></a>
## [1.5.6] - 2021-02-03
<a name="1.5.5"></a>
## [1.5.5] - 2021-01-26
<a name="1.5.4"></a>
## [1.5.4] - 2021-01-15
<a name="1.5.3"></a>
## [1.5.3] - 2021-01-06
### Bug Fixes
- FileHandle exceptions and lens processor crash

<a name="1.5.2"></a>
## [1.5.2] - 2020-12-22
<a name="1.5.1"></a>
## [1.5.1] - 2020-12-22
<a name="1.5.0"></a>
## [1.5.0] - 2020-12-03
### Bug Fixes
- CarouselView crashing sometimes when swiping

### Features
- Add first frame ready event to processor observer

<a name="1.4.5"></a>
## [1.4.5] - 2020-12-01

<a name="1.4.4"></a>
## [1.4.4] - 2020-11-20

<a name="1.4.3"></a>
## [1.4.3] - 2020-11-18

<a name="1.4.2"></a>
## [1.4.2] - 2020-11-17

<a name="1.4.1"></a>
## [1.4.1] - 2020-11-16
### Bug Fixes
- Lock orientation when recording
- Carousel sometimes resetting transform on reloading data
- ARKit video is stretched
- Image hints are present in videos
- Some lenses won't download after the internet is back
- Bundled hints not localizing properly if host app doesn't support localization
- Recorded video frozen when returning from background

### Features
- Add LiDAR support
- Improve AVSessionInput camera performance
- Expose lens preview model

<a name="1.3.6"></a>
## [1.3.6] - 2020-11-04
### Bug Fixes
- Some lenses won't download after the internet is back
- Race condition sometimes when retrying requests due to no internet
- Requests sometime failing if app is open for too long
- Lens repo sometimes returning stale data

### Features
- Expose lens preview model

<a name="1.4.0"></a>
## [1.4.0] - 2020-10-28
### Bug Fixes
- ARKit video is stretched
- Image hints are present in videos
- Some lenses won't download after the internet is back
- Bundled hints not localizing properly if host app doesn't support localization
- Recorded video frozen when returning from background

### Features
- Add LiDAR support
- Improve AVSessionInput camera performance
- Expose lens preview model

<a name="1.3.5"></a>
## [1.3.5] - 2020-10-20
<a name="1.3.4"></a>
## [1.3.4] - 2020-10-15
### Features
- Expose lens preview model

<a name="1.3.3"></a>
## [1.3.3] - 2020-10-15
<a name="1.3.2"></a>
## [1.3.2] - 2020-10-15

<a name="1.3.1"></a>
## [1.3.1] - 2020-10-09
### Bug Fixes
- Some lenses won't download after the internet is back
- Race condition sometimes when retrying requests due to no internet
- Requests sometime failing if app is open for too long

<a name="1.3.0"></a>
## [1.3.0] - 2020-09-25
<a name="1.2.0"></a>
## [1.2.0] - 2020-08-27
### Features
- Invalidate metadata cache on cold-start when network is available

<a name="1.1.0"></a>
## [1.1.0] - 2020-07-29
### Features
- Add support for dynamic lens launch data
- Expose user data provider

<a name="1.0.0"></a>
## [1.0.0] - 2020-07-08
### Features
- Expose vendor data
- Add lens prefetcher support
- Add support for ARKit
- Add support for localized hints

<a name="0.5.0"></a>
## [0.5.0] - 2020-06-03
<a name="0.4.0"></a>
## [0.4.0] - 2020-04-22
### Bug Fixes
- Original lens should be active on app opening
- First lens doesn't work on fresh install
- Carousel in landscape is not aligned
- Fix carousel ux: close button goes to empty lens

### Features
- Add processor observer
- Add share to Snapchat
- Capture and image preview support
- Add support for remote assets and unbundle tracking data
- Add sample video preview

<a name="0.3.0"></a>
## [0.3.0] - 2020-03-30
### Bug Fixes
- Correct effect viewport and aspect ratio for lenses

### Features
- Restructure Repository API
- Add video recording support
- Add sample UI and migrate CameraViewController to reference UI
- Add snap camera button
- Add Carousel

<a name="0.2.0"></a>
## [0.2.0] - 2020-02-27
### Features
- Add support for remote lens metadata and content

<a name="0.1.0"></a>
## 0.1.0 - 2020-02-12
### Bug Fixes
- Re-apply lens when entering foreground

### Features
- Add Camera Flip Button
- add prev next buttons to flip between lenses
- use lens name property

