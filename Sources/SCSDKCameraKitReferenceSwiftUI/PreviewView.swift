//  Copyright Snap Inc. All rights reserved.

import SCSDKCameraKit
import SwiftUI

/// SwiftUI wrapper for the CameraKit preview view.
public struct PreviewView: UIViewRepresentable {
    private let inner = SCSDKCameraKit.PreviewView()
    private let cameraKit: CameraKitProtocol

    /// Initializes a preview view and connects it to a CameraKit session as an output
    /// - Parameter cameraKit: the session to attach the preview view as an output to
    /// - Parameter automaticallyConfiguresTouchHandler: whether or not touch handling should automatically be configured for the view
    public init(cameraKit: CameraKitProtocol, automaticallyConfiguresTouchHandler: Bool = true) {
        self.cameraKit = cameraKit
        inner.automaticallyConfiguresTouchHandler = automaticallyConfiguresTouchHandler
    }

    public func makeUIView(context: Context) -> some UIView {
        cameraKit.add(output: inner)
        return inner
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
