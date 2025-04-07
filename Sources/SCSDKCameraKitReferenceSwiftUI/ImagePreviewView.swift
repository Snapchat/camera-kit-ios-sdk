//  Copyright Snap Inc. All rights reserved.

import SCSDKCameraKit
import SCSDKCameraKitReferenceUI
import SwiftUI

/// SwiftUI wrapper for the reference UI captured image preview view controller.
public struct ImagePreviewView: UIViewControllerRepresentable {
    private let image: UIImage
    private weak var snapchatDelegate: SnapchatDelegate?

    /// Creates a preview view.
    /// - Parameters:
    ///   - image: the captured image to show
    ///   - snapchatDelegate: the Snapchat delegate
    public init(image: UIImage, snapchatDelegate: SnapchatDelegate?) {
        self.image = image
        self.snapchatDelegate = snapchatDelegate
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        let inner = ImagePreviewViewController(image: image)
        inner.snapchatDelegate = snapchatDelegate
        return inner
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
