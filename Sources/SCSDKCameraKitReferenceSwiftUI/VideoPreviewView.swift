//  Copyright Snap Inc. All rights reserved.

import SCSDKCameraKit
import SCSDKCameraKitReferenceUI
import SwiftUI

/// SwiftUI wrapper for the reference UI captured video preview view controller.
public struct VideoPreviewView: UIViewControllerRepresentable {
    private let video: URL
    private weak var snapchatDelegate: SnapchatDelegate?

    /// Creates a preview view.
    /// - Parameters:
    ///   - video: the url for the recorded video to show
    ///   - snapchatDelegate: the Snapchat delegate
    public init(video: URL, snapchatDelegate: SnapchatDelegate?) {
        self.video = video
        self.snapchatDelegate = snapchatDelegate
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        let inner = VideoPreviewViewController(videoUrl: video)
        inner.snapchatDelegate = snapchatDelegate
        return inner
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
