//  Copyright Snap Inc. All rights reserved.

import SCSDKCameraKit
import SCSDKCameraKitReferenceUI
import SwiftUI

@available(iOS 14.0, *)
/// A sample implementation of a minimal SwiftUI view for a CameraKit camera experience.
public struct CameraView: View {
    /// Relevant state for the view
    @StateObject private var state = CameraViewState()

    /// A controller which manages the camera and lenses stack on behalf of the view
    private var cameraController: CameraController

    public init(cameraController: CameraController) {
        self.cameraController = cameraController
        cameraController.configure(
            orientation: .portrait, textInputContextProvider: nil, agreementsPresentationContextProvider: nil,
            completion: nil
        )
    }

    public var body: some View {
        ZStack {
            PreviewView(cameraKit: cameraController.cameraKit)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(count: 2, perform: cameraController.flipCamera)
                .gesture(
                    MagnificationGesture(minimumScaleDelta: 0)
                        .onChanged(cameraController.zoomExistingLevel(by:))
                        .onEnded { _ in
                            cameraController.finalizeZoom()
                        })
            VStack {
                LensHeader(
                    lensName: cameraController.currentLens?.name ?? "", flipCameraAction: cameraController.flipCamera
                )
                MessageView(
                    lensName: cameraController.currentLens?.name ?? "", lensID: cameraController.currentLens?.id ?? "",
                    showing: state.showingMessage
                )
                Spacer()
                MediaPickerView(provider: cameraController.lensMediaProvider)
                LensFooter(state: state, cameraController: cameraController)
            }
            HintView(hint: state.hint)
            ProgressView()
                .opacity(state.loading ? 1 : 0)
        }.onAppear {
            state.cameraController = cameraController
        }
        .sheet(item: $state.captured, onDismiss: cameraController.reapplyCurrentLens) { item in
            switch item {
            case let .photo(image):
                ImagePreviewView(image: image, snapchatDelegate: cameraController.snapchatDelegate)
                    .edgesIgnoringSafeArea(.bottom)
            case let .video(url):
                VideoPreviewView(video: url, snapchatDelegate: cameraController.snapchatDelegate)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

/// A sample implementation of a header view, which shows the lens name and a camera flip button
struct LensHeader: View {
    /// The name of the currently selected lens.
    let lensName: String

    /// An action to call when the camera flip button is tapped.
    let flipCameraAction: () -> Void

    var body: some View {
        ZStack {
            Text(lensName)
                .frame(alignment: .center)
                .font(.headline)
                .foregroundColor(.white)
            HStack {
                Spacer()
                Button(action: flipCameraAction) {
                    Image("ck_camera_flip", bundle: BundleHelper.resourcesBundle)
                }
            }
        }.padding()
    }
}

@available(iOS 14.0, *)
/// A reference implementation of a footer view, which contains a lens carousel, a camera button, and a close button
struct LensFooter: View {
    /// The state of the camera view.
    @ObservedObject var state: CameraViewState

    /// The camera controller.
    let cameraController: CameraController

    var body: some View {
        ZStack {
            CarouselView(availableLenses: $state.lenses, selectedLens: $state.selectedLens)
            CameraButton(
                recordingStart: cameraController.startRecording, recordingCancel: cameraController.cancelRecording,
                recordingFinish: {
                    cameraController.finishRecording { url, _ in
                        guard let url else { return }
                        state.captured = .video(url: url)
                        cameraController.clearLens(willReapply: true)
                    }
                },
                photoCapture: {
                    cameraController.takePhoto { image, _ in
                        guard let image else { return }
                        state.captured = .photo(image: image)
                        cameraController.clearLens(willReapply: true)
                    }
                }
            )
        }
        Button(
            action: {
                state.selectedLens = nil
            },
            label: {
                Image("ck_close_circle", bundle: BundleHelper.resourcesBundle)
            }
        )
        .padding(.top)
        .opacity(state.selectedLens == nil ? 0 : 1)
    }
}

/// A reference implementation of a message view, which shows the selected lens name and ID
struct MessageView: View {
    /// The name of the currently selected lens.
    let lensName: String

    /// The ID of the currently selected lens.
    let lensID: String

    /// Whether or not the message view is being displayed.
    let showing: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(lensName)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(lensID)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color(white: 0, opacity: 0.65))
            .cornerRadius(4)
            .opacity(showing ? 1 : 0)
            .animation(.easeInOut, value: showing)
            .padding()
            Spacer()
        }
    }
}

/// A reference implementation of a hint view, which shows hints requested to be displayed by a lens
struct HintView: View {
    /// The hint to be displayed.
    let hint: String?

    var body: some View {
        Text(hint ?? "")
            .font(.system(size: 20))
            .bold()
            .foregroundColor(.white)
            .opacity(hint == nil ? 0 : 1)
    }
}
