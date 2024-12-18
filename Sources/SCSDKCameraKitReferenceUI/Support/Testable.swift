//  Copyright Snap Inc. All rights reserved.

import Foundation

/// Describes an element that can be UI tested
public protocol TestableElement {
    /// identifier for the testable element
    var id: String { get }
}

public extension TestableElement where Self: RawRepresentable {
    var id: String {
        "\(String(describing: type(of: self)))_\(rawValue)"
    }
}

// MARK: Camera Bottom Bar

/// CameraBottomBar view testable elements
public enum CameraBottomBarElements: String, TestableElement {
    case closeButton
}

// MARK: Camera View

/// CameraViewController testable elements
public enum CameraElements: String, TestableElement {
    case lensLabel
    case flipCameraButton
    case flashToggleButton
    case flashConfigurationButton
    case flashControl
    case flashControlDismissalHint
    case toneMapToggleButton
    case toneMapConfigurationButton
    case toneMapControl
    case toneMapControlDismissalHint
    case portraitToggleButton
    case portraitConfigurationButton
    case portraitControl
    case portraitControlDismissalHint
    case ringLightView
    case photoLibraryButton
    case cameraButton
}

public extension CameraElements {
    enum CameraFlip {
        public static let front = "front"
        public static let back = "back"
    }
}

// MARK: Carousel

/// CarouselView testable elements
public enum CarouselElements: String, TestableElement {
    case collectionView
    case lensCell
    case facadeSelectionRingView
}

// MARK: Preview

/// PreviewViewController testable elements
public enum PreviewElements: String, TestableElement {
    case closeButton
    case snapchatButton
    case shareButton
    case imageView
    case playerControllerView
}

// MARK: Message Notification

/// MessageNotificationView testable elements
public enum MessageNotificationElements: String, TestableElement {
    case label
}

// MARK: Flash Control

/// FlashControlView testable elements
public enum FlashControlElements: String, TestableElement {
    case flashModeSelector
    case ringLightColorSelector
    case ringLightIntensitySlider
}

// MARK: Other Elements

/// Other misc testable elements
public enum OtherElements: String, TestableElement {
    case noOpButton
    case arkitButton
    case agreementsButton
    case tapToFocusView
    case pairingButton
    case connectedLensStartButton
    case mirrorButton
}
