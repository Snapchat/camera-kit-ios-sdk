//  Copyright Snap Inc. All rights reserved.

import SCSDKCameraKit
import SCSDKCameraKitReferenceUI
import SwiftUI

/// SwiftUI wrapper for the reference UI camera button.
public struct CameraButton: UIViewRepresentable {
    /// A closure to be called when a photo is captured
    private let photoCaptureAction: (() -> Void)?

    /// A closure to be called when the user begins recording
    private let recordingStartAction: (() -> Void)?

    /// A closure to be called when the user cancels recording. Will be immediately followed by the execution of photoCaptureAction
    private let recordingCancelAction: (() -> Void)?

    /// A closure to be called when the user completes recording
    private let recordingFinishAction: (() -> Void)?

    /// Initializes the camera button
    /// - Parameters:
    ///   - recordingStart: A closure to be called when the user begins recording
    ///   - recordingCancel: A closure to be called when the user cancels recording. Will be immediately followed by the execution of photoCaptureAction
    ///   - recordingFinish: A closure to be called when the user cancels recording. Will be immediately followed by the execution of photoCaptureAction
    ///   - photoCapture: A closure to be called when a photo is captured
    init(
        recordingStart: (() -> Void)?, recordingCancel: (() -> Void)?, recordingFinish: (() -> Void)?,
        photoCapture: (() -> Void)?
    ) {
        self.recordingStartAction = recordingStart
        self.recordingCancelAction = recordingCancel
        self.recordingFinishAction = recordingFinish
        self.photoCaptureAction = photoCapture
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> some UIView {
        let inner = SCSDKCameraKitReferenceUI.CameraButton()
        inner.delegate = context.coordinator
        return inner
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

public extension CameraButton {
    class Coordinator: NSObject, CameraButtonDelegate {
        let parent: CameraButton

        init(_ parent: CameraButton) {
            self.parent = parent
        }

        public func cameraButtonTapped(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
            parent.photoCaptureAction?()
        }

        public func cameraButtonHoldBegan(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
            parent.recordingStartAction?()
        }

        public func cameraButtonHoldCancelled(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
            parent.recordingCancelAction?()
        }

        public func cameraButtonHoldEnded(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
            parent.recordingFinishAction?()
        }
    }
}
