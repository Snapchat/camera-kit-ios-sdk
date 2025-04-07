//  Copyright Snap Inc. All rights reserved.

import SCSDKCameraKit
import SCSDKCameraKitReferenceUI
import SwiftUI

/// SwiftUI wrapper for the reference UI media picker.
public struct MediaPickerView: View {
    private let provider: LensMediaPickerProvider
    @State private var hidden: Bool = true

    /// Initializes the media picker view with a media picker provider
    /// - Parameter provider: the provider to use
    public init(provider: LensMediaPickerProvider) {
        self.provider = provider
    }

    public var body: some View {
        _MediaPickerView(provider: provider, hidden: $hidden)
            .padding([.leading, .trailing])
    }
}

private struct _MediaPickerView: UIViewRepresentable {
    private let provider: LensMediaPickerProvider
    fileprivate let inner = SCSDKCameraKitReferenceUI.MediaPickerView()
    @Binding var hidden: Bool

    init(provider: LensMediaPickerProvider, hidden: Binding<Bool>) {
        self.provider = provider
        self._hidden = hidden
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> SCSDKCameraKitReferenceUI.MediaPickerView {
        provider.uiDelegate = context.coordinator
        inner.provider = provider
        return inner
    }

    public func updateUIView(_ uiView: SCSDKCameraKitReferenceUI.MediaPickerView, context: Context) {
    }
}

extension _MediaPickerView {
    class Coordinator: NSObject, LensMediaPickerProviderUIDelegate {
        let parent: _MediaPickerView

        init(_ parent: _MediaPickerView) {
            self.parent = parent
        }

        func mediaPickerProviderRequestedUIPresentation(_ provider: LensMediaPickerProvider) {
            parent.inner.mediaPickerProviderRequestedUIPresentation(provider)
            parent.hidden = false
        }

        func mediaPickerProviderRequestedUIDismissal(_ provider: LensMediaPickerProvider) {
            parent.inner.mediaPickerProviderRequestedUIDismissal(provider)
            parent.hidden = true
        }
    }
}
