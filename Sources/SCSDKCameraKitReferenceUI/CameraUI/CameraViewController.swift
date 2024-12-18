//  Copyright Snap Inc. All rights reserved.

import AVFoundation
import AVKit
import SCSDKCameraKit
import UIKit

/// Describes an interface to control app orientation
public protocol AppOrientationDelegate: AnyObject {
    /// Lock app orientation
    /// - Parameter orientation: interface orientation mask to lock orientations to
    func lockOrientation(_ orientation: UIInterfaceOrientationMask)

    /// Unlock orientation
    func unlockOrientation()
}

/// This is the default view controller which handles setting up the camera, lenses, carousel, etc.
open class CameraViewController: UIViewController, CameraControllerUIDelegate {
    // MARK: CameraKit properties

    /// A controller which manages the camera and lenses stack on behalf of the view controller
    public let cameraController: CameraController

    /// App orientation delegate to control app orientation
    public weak var appOrientationDelegate: AppOrientationDelegate?
    
    private var lastUsedOrientation = UIInterfaceOrientation.portrait

    /// convenience prop to get current interface orientation of application/scene
    fileprivate var applicationInterfaceOrientation: UIInterfaceOrientation {
        var interfaceOrientation = UIApplication.shared.statusBarOrientation
        if
            #available(iOS 13, *),
            let sceneOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        {
            interfaceOrientation = sceneOrientation
        }
        return interfaceOrientation
    }

    /// convenience prop to get current interface orientation mask to lock device from rotation
    fileprivate var currentInterfaceOrientationMask: UIInterfaceOrientationMask {
        switch applicationInterfaceOrientation {
        case .portrait, .unknown: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        @unknown default:
            return .portrait
        }
    }

    // The backing view
    public let cameraView = CameraView()

    override open func loadView() {
        view = cameraView
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraController.increaseBrightnessIfNecessary()
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraController.restoreBrightnessIfNecessary()
    }

    // MARK: Init

    /// Returns a camera view controller initialized with a camera controller that is configured with a newly created AVCaptureSession stack
    /// and CameraKit session with the specified configuration and list of group IDs.
    /// - Parameters:
    ///   - repoGroups: List of group IDs to observe.
    ///   - sessionConfig: Config to configure session with application id and api token.
    ///   Pass this in if you wish to dynamically update or overwrite the application id and api token in the application's `Info.plist`.
    public convenience init(repoGroups: [String], sessionConfig: SessionConfig? = nil) {
        // Max size of lens content cache = 150 * 1024 * 1024 = 150MB
        // 150MB to make sure that some lenses that use large assets such as the ones required for
        // 3D body tracking (https://lensstudio.snapchat.com/templates/object/3d-body-tracking) have
        // enough cache space to fit alongside other lenses.
        let lensesConfig = LensesConfig(cacheConfig: CacheConfig(lensContentMaxSize: 150 * 1024 * 1024))
        let cameraKit = Session(sessionConfig: sessionConfig, lensesConfig: lensesConfig, errorHandler: nil)
        let captureSession = AVCaptureSession()
        self.init(cameraKit: cameraKit, captureSession: captureSession, repoGroups: repoGroups)
    }

    /// Convenience init to configure a camera controller with a specified AVCaptureSession stack, CameraKit, and list of group IDs.
    /// - Parameters:
    ///   - cameraKit: camera kit session
    ///   - captureSession: a backing AVCaptureSession to use
    ///   - repoGroups: the group IDs to observe
    public convenience init(cameraKit: CameraKitProtocol, captureSession: AVCaptureSession, repoGroups: [String]) {
        let cameraController = CameraController(cameraKit: cameraKit, captureSession: captureSession)
        cameraController.groupIDs = repoGroups
        self.init(cameraController: cameraController)
    }

    /// Initialize the view controller with a preconfigured camera controller
    /// - Parameter cameraController: the camera controller to use.
    public init(cameraController: CameraController) {
        self.cameraController = cameraController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overridable Helper

    /// get message to display in popup view for selected lens
    /// - Parameter lens: selected lens
    open func getMessage(lens: Lens) -> String {
        var text = lens.name ?? lens.id

        if lens.name != nil {
            text.append("\n\(lens.id)")
        }

        return text
    }

    /// Displays a message indicating that a specified lens has been displayed
    /// - Parameter lens: the lens to display info for.
    open func showMessage(lens: Lens) {
        let message = getMessage(lens: lens)
        cameraView.showMessage(text: message, numberOfLines: message.components(separatedBy: "\n").count)
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        cameraController.cameraKit.videoOrientation = videoOrientation(
            from: orientation(from: lastUsedOrientation, transform: coordinator.targetTransform))
        coordinator.animate { _ in } completion: { [self] _ in
            // pre-iOS16 returns 'old' orientation, so we should capture value in completion block
            lastUsedOrientation = applicationInterfaceOrientation
        }
    }

    // MARK: Lenses Setup

    /// Apply a specific lens
    /// - Parameters:
    ///   - lens: selected lens
    open func applyLens(_ lens: Lens) {
        cameraView.activityIndicator.stopAnimating() // stop any loading indicator that may still be going on from previous lens
        cameraController.applyLens(lens) { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                print("\(lens.name ?? "Unnamed") (\(lens.id)) Applied")

                DispatchQueue.main.async {
                    strongSelf.hideAllHints()
                    strongSelf.showMessage(lens: lens)
                    strongSelf.cameraView.cameraBottomBar.closeButton.isHidden = false
                    strongSelf.cameraView.lensLabel.text = lens.name ?? lens.id
                }
            }
        }
    }

    /// Helper function to clear currently selected lens
    open func clearLens() {
        cameraView.activityIndicator.stopAnimating() // stop any loading indicator that may still be going on from current lens
        cameraController.clearLens(completion: nil)
        cameraView.cameraBottomBar.closeButton.isHidden = true
        cameraView.lensLabel.text = ""
    }

    // MARK: CameraControllerUIDelegate

    open func cameraController(_ controller: CameraController, updatedLenses lenses: [Lens]) {
        cameraView.carouselView.reloadData()
        let selectedItem = cameraView.carouselView.selectedItem

        if !(selectedItem is EmptyItem) {
            cameraView.carouselView.selectItem(selectedItem)
        }
    }

    open func cameraControllerRequestedActivityIndicatorShow(_ controller: CameraController) {
        cameraView.activityIndicator.startAnimating()
    }

    open func cameraControllerRequestedActivityIndicatorHide(_ controller: CameraController) {
        cameraView.activityIndicator.stopAnimating()
    }

    open func cameraControllerRequestedRingLightShow(_ controller: CameraController) {
        cameraView.ringLightView.isHidden = false
    }

    open func cameraControllerRequestedRingLightHide(_ controller: CameraController) {
        cameraView.ringLightView.isHidden = true
    }

    open func cameraControllerRequestedFlashControlHide(_ controller: CameraController) {
        cameraView.flashControlView.isHidden = true
    }

    open func cameraControllerRequestedSnapAttributionViewShow(_ controller: CameraController) {
        cameraView.snapAttributionView.isHidden = false
    }

    open func cameraControllerRequestedSnapAttributionViewHide(_ controller: CameraController) {
        cameraView.snapAttributionView.isHidden = true
    }

    open func cameraControllerRequestedCameraFlip(_ controller: CameraController) {
        flip(sender: controller)
    }

    open func cameraController(
        _ controller: CameraController, requestedHintDisplay hint: String, for lens: Lens, autohide: Bool
    ) {
        guard lens.id == cameraController.currentLens?.id else { return }

        cameraView.hintLabel.text = hint
        cameraView.hintLabel.layer.removeAllAnimations()
        cameraView.hintLabel.alpha = 0.0

        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.cameraView.hintLabel.alpha = 1.0
            }
        ) { completed in
            guard autohide, completed else { return }
            UIView.animate(
                withDuration: 0.5, delay: 2.0,
                animations: {
                    self.cameraView.hintLabel.alpha = 0.0
                }, completion: nil
            )
        }
    }

    open func cameraController(_ controller: CameraController, requestedHintHideFor lens: Lens) {
        hideAllHints()
    }

    private func hideAllHints() {
        cameraView.hintLabel.layer.removeAllAnimations()
        cameraView.hintLabel.alpha = 0.0
    }
}

// MARK: General Camera Setup

private extension CameraViewController {
    /// Calls the relevant setup methods on the camera controller
    func setup() {
        lastUsedOrientation = applicationInterfaceOrientation
        cameraController.configure(
            orientation: videoOrientation(from: applicationInterfaceOrientation),
            textInputContextProvider: TextInputContextProviderImpl(cameraViewController: self),
            agreementsPresentationContextProvider: AgreementsPresentationContextProviderImpl(
                cameraViewController: self),
            completion: { [weak self] in
                // Re-check adjustment availability and add observer only after completion, because during first setup
                // permissions may not have been granted yet/the session may not start immediately until permissions
                // are granted.
                guard let self else { return }
                self.updateAdjustmentButtonStatus()
                self.cameraController.cameraKit.adjustments.processor?.addObserver(self)
            }
        )
        setupActions()
        cameraController.cameraKit.add(output: cameraView.previewView)
        cameraController.uiDelegate = self
        setupSystemNotificationObservers()
    }

    /// Configures the target actions and delegates needed for the view controller to function
    func setupActions() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        cameraView.previewView.addGestureRecognizer(singleTap)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(flip(sender:)))
        doubleTap.numberOfTapsRequired = 2
        cameraView.previewView.addGestureRecognizer(doubleTap)

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoom(sender:)))
        cameraView.previewView.addGestureRecognizer(pinchGestureRecognizer)
        cameraView.previewView.automaticallyConfiguresTouchHandler = true

        cameraView.cameraBottomBar.closeButton.addTarget(
            self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside
        )
        cameraView.cameraBottomBar.snapButton.addTarget(
            self, action: #selector(snapchatButtonPressed(_:)), for: .touchUpInside
        )

        cameraView.cameraActionsView.flipCameraButton.addTarget(
            self, action: #selector(flip(sender:)), for: .touchUpInside
        )

        setupFlashButtons()
        setupToneMapAdjustmentButtons()
        setupPortraitAdjustmentButtons()

        cameraView.carouselView.delegate = self
        cameraView.carouselView.dataSource = self

        cameraView.cameraButton.delegate = self
        cameraView.cameraButton.allowWhileRecording = [doubleTap, pinchGestureRecognizer]

        cameraView.mediaPickerView.provider = cameraController.lensMediaProvider
        cameraView.mediaPickerView.delegate = cameraController
        cameraController.lensMediaProvider.uiDelegate = cameraView.mediaPickerView

        cameraView.toneMapControlView.delegate = cameraController
        cameraView.portraitControlView.delegate = cameraController

        cameraView.flashControlView.delegate = self
    }
}

// MARK: Camera Bottom Bar

extension CameraViewController {
    /// Clears the current lens and scrolls the carousel back to the "empty" item.
    /// - Parameter sender: the caller
    @objc
    private func closeButtonPressed(_ sender: UIButton) {
        clearLens()
        cameraView.carouselView.selectItem(EmptyItem())
    }

    /// Opens Snapchat to the lens or profile specified
    /// - Parameter sender: the caller
    @objc
    private func snapchatButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let lens = cameraController.currentLens {
            let lensAction = UIAlertAction(title: "Open Lens in Snapchat", style: .default) { _ in
                self.cameraController.snapchatDelegate?.cameraKitViewController(self, openSnapchat: .lens(lens))
            }

            alertController.addAction(lensAction)
        }

        let profileAction = UIAlertAction(title: "View Profile on Snapchat", style: .default) { _ in
            self.cameraController.snapchatDelegate?.cameraKitViewController(self, openSnapchat: .profile)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(profileAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: Single Tap

extension CameraViewController {
    /// Handles a single tap gesture by dismissing the tone map control if it is visible and setting the point
    /// of interest otherwise.
    /// - Parameter sender: The single tap gesture recognizer.
    @objc
    private func handleSingleTap(sender: UITapGestureRecognizer) {
        if cameraView.isAnyControlVisible {
            cameraView.hideAllControls()
        } else {
            setPointOfInterest(sender: sender)
        }
    }
}

// MARK: Camera Point of Interest

private extension CameraViewController {
    /// Sets the camera's point of interest for focus and exposure based on where the user tapped
    /// - Parameter sender: the caller
    @objc
    func setPointOfInterest(sender: UITapGestureRecognizer) {
        cameraView.drawTapAnimationView(at: sender.location(in: sender.view))

        guard let focusPoint = sender.captureDevicePoint else { return }

        cameraController.setPointOfInterest(at: focusPoint)
    }
}

// MARK: Camera Flip

private extension CameraViewController {
    /// Flips the camera
    /// - Parameter sender: the caller
    @objc
    func flip(sender: Any) {
        cameraController.flipCamera()
        switch cameraController.cameraPosition {
        case .front:
            cameraView.cameraActionsView.setupFlashToggleButtonForFront()
            cameraView.cameraActionsView.flipCameraButton.accessibilityValue = CameraElements.CameraFlip.front
        case .back:
            cameraView.cameraActionsView.setupFlashToggleButtonForBack()
            cameraView.cameraActionsView.flipCameraButton.accessibilityValue = CameraElements.CameraFlip.back
        default:
            break
        }
    }
}

// MARK: Adjustment Observer

extension CameraViewController: AdjustmentsProcessorObserver {
    public func processorUpdatedAdjustmentsAvailability(_ adjustmentsProcessor: AdjustmentsProcessor) {
        updateAdjustmentButtonStatus()
    }

    func updateAdjustmentButtonStatus() {
        cameraView.cameraActionsView.toneMapActionView.isHidden = !cameraController.isToneMapAdjustmentAvailable
        cameraView.cameraActionsView.portraitActionView.isHidden = !cameraController.isPortraitAdjustmentAvailable
    }
}

// MARK: System Notification Observers

extension CameraViewController {
    @objc
    private func increaseBrightnessIfNecessary() {
        cameraController.increaseBrightnessIfNecessary()
    }

    @objc
    private func restoreBrightnessIfNecessary() {
        cameraController.restoreBrightnessIfNecessary()
    }

    private func setupSystemNotificationObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(restoreBrightnessIfNecessary), name: UIApplication.willResignActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(increaseBrightnessIfNecessary), name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(restoreBrightnessIfNecessary), name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
}

// MARK: Tone Map Adjustment

extension CameraViewController {
    private func setupToneMapAdjustmentButtons() {
        cameraView.cameraActionsView.toneMapActionView.isHidden = !cameraController.isToneMapAdjustmentAvailable

        cameraView.cameraActionsView.toneMapActionView.enableAction = { [weak self] in
            guard let strongSelf = self else { return }
            let amount = strongSelf.cameraController.enableToneMapAdjustment()
            if let amount {
                strongSelf.cameraView.toneMapControlView.intensityValue = amount
            }
        }

        cameraView.cameraActionsView.toneMapActionView.disableAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cameraController.disableToneMapAdjustment()
        }
    }
}

// MARK: Portrait Adjustment

extension CameraViewController {
    private func setupPortraitAdjustmentButtons() {
        cameraView.cameraActionsView.portraitActionView.isHidden = !cameraController.isPortraitAdjustmentAvailable

        cameraView.cameraActionsView.portraitActionView.enableAction = { [weak self] in
            guard let strongSelf = self else { return }
            let blur = strongSelf.cameraController.enablePortraitAdjustment()
            if let blur {
                strongSelf.cameraView.portraitControlView.intensityValue = blur
            }
        }

        cameraView.cameraActionsView.portraitActionView.disableAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cameraController.disablePortraitAdjustment()
        }
    }
}

// MARK: Camera Zoom

private extension CameraViewController {
    /// Zooms the camera based on a pinch gesture
    /// - Parameter sender: the caller
    @objc
    func zoom(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .changed:
            cameraController.zoomExistingLevel(by: sender.scale)
        case .ended:
            cameraController.finalizeZoom()
        default:
            break
        }
    }
}

// MARK: Carousel

extension CameraViewController: CarouselViewDelegate, CarouselViewDataSource {
    public func carouselView(_ view: CarouselView, didSelect item: CarouselItem, at index: Int) {
        // first item is empty item
        guard index > 0 else {
            clearLens()
            return
        }

        guard let lens = cameraController.cameraKit.lenses.repository.lens(id: item.lensId, groupID: item.groupId)
        else { return }
        applyLens(lens)
    }

    public func itemsForCarouselView(_ view: CarouselView) -> [CarouselItem] {
        [EmptyItem()]
            + cameraController.groupIDs.flatMap {
                cameraController.cameraKit.lenses.repository.lenses(groupID: $0).map {
                    CarouselItem(lensId: $0.id, groupId: $0.groupId, imageUrl: $0.iconUrl)
                }
            }
    }
}

// MARK: Camera Button

extension CameraViewController: CameraButtonDelegate {
    public func cameraButtonTapped(_ cameraButton: CameraButton) {
        print("Camera button tapped")
        cameraController.takePhoto { image, error in
            guard let image else { return }
            DispatchQueue.main.async {
                self.cameraController.restoreBrightnessIfNecessary()
                let viewController = ImagePreviewViewController(image: image)
                viewController.snapchatDelegate = self.cameraController.snapchatDelegate
                viewController.presentationController?.delegate = self
                viewController.onDismiss = { [weak self] in
                    self?.cameraController.reapplyCurrentLens()
                    self?.cameraController.increaseBrightnessIfNecessary()
                }
                self.present(viewController, animated: true) { [weak self] in
                    self?.cameraController.clearLens(willReapply: true)
                }
            }
        }
    }

    public func cameraButtonHoldBegan(_ cameraButton: CameraButton) {
        print("Start recording")
        cameraController.startRecording()
        cameraView.hideAllControls()
        UIView.animate(
            withDuration: 0.15,
            animations: { [weak self] in
                self?.cameraView.cameraActionsView.collapse()
            }
        )
        cameraView.carouselView.hideCarousel()
        appOrientationDelegate?.lockOrientation(currentInterfaceOrientationMask)
        if #available(iOS 16.0, *) {
            UIView.performWithoutAnimation {
                setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        }
        cameraView.mediaPickerView.dismiss()
    }

    public func cameraButtonHoldCancelled(_ cameraButton: CameraButton) {
        cameraController.cancelRecording()
        restoreActiveCameraState()
    }

    public func cameraButtonHoldEnded(_ cameraButton: CameraButton) {
        print("Finish recording")
        cameraController.finishRecording { url, error in
            DispatchQueue.main.async {
                guard let url else { return }
                self.cameraController.clearLens(willReapply: true)
                self.cameraController.restoreBrightnessIfNecessary()
                let player = VideoPreviewViewController(videoUrl: url)
                player.snapchatDelegate = self.cameraController.snapchatDelegate
                player.presentationController?.delegate = self
                player.onDismiss = { [weak self] in
                    self?.cameraController.reapplyCurrentLens()
                    self?.cameraController.increaseBrightnessIfNecessary()
                }
                self.present(player, animated: true) {
                    self.restoreActiveCameraState()
                }
            }
        }
    }

    private func restoreActiveCameraState() {
        cameraView.cameraActionsView.expand()
        cameraView.carouselView.showCarousel()
        appOrientationDelegate?.unlockOrientation()
        if #available(iOS 16.0, *) {
            UIView.performWithoutAnimation {
                setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        }
    }
}

// MARK: Ring Light Control Delegate

extension CameraViewController: FlashControlViewDelegate {
    public func flashControlView(_ view: FlashControlView, updatedRingLightValue value: Float) {
        cameraView.ringLightView.ringLightGradient.updateIntensity(to: CGFloat(value), animated: true)
    }

    public func flashControlView(_ view: FlashControlView, selectedRingLightColor color: UIColor) {
        cameraView.ringLightView.changeColor(to: color)
    }

    public func flashControlView(_ view: FlashControlView, updatedFlashMode flashMode: CameraController.FlashMode) {
        cameraController.flashState = .on(flashMode)
    }
}

// MARK: Flash Buttons

extension CameraViewController {
    private func setupFlashButtons() {
        cameraView.cameraActionsView.flashActionView.enableAction = { [weak self] in
            self?.cameraController.enableFlash()
        }

        cameraView.cameraActionsView.flashActionView.disableAction = { [weak self] in
            self?.cameraController.disableFlash()
        }
    }
}

private extension MediaPickerView {
    func dismiss() {
        if let provider {
            mediaPickerProviderRequestedUIDismissal(provider)
        }
    }
}

// MARK: Presentation Delegate

extension CameraViewController: UIAdaptivePresentationControllerDelegate {
    open func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        guard presentationController.presentedViewController is PreviewViewController else { return }
        cameraController.reapplyCurrentLens()
        cameraController.increaseBrightnessIfNecessary()
    }
}

// MARK: Agreements presentation context

extension CameraViewController {
    class AgreementsPresentationContextProviderImpl: NSObject, AgreementsPresentationContextProvider {
        weak var cameraViewController: CameraViewController?

        init(cameraViewController: CameraViewController) {
            self.cameraViewController = cameraViewController
        }

        public var viewControllerForPresentingAgreements: UIViewController {
            cameraViewController ?? UIApplication.shared.keyWindow!.rootViewController!
        }

        public func dismissAgreementsViewController(_ viewController: UIViewController, accepted: Bool) {
            viewController.dismiss(animated: true, completion: nil)
            if !accepted {
                if cameraViewController?.cameraController.currentLens == nil {
                    cameraViewController?.cameraView.carouselView.selectItem(EmptyItem())
                }
            } else {
                cameraViewController?.cameraView.snapAttributionView.isHidden = false
            }
        }
    }
}

// MARK: Text input context

extension CameraViewController {
    class TextInputContextProviderImpl: NSObject, TextInputContextProvider {
        public let keyboardAccessoryProvider: TextInputKeyboardAccessoryProvider? = KeyboardAccessoryViewProvider()
        weak var cameraViewController: CameraViewController?

        init(cameraViewController: CameraViewController) {
            self.cameraViewController = cameraViewController
        }

        public var parentView: UIView? {
            cameraViewController?.view
        }
    }
}

// MARK: Orientation Helper

private extension CameraViewController {
    /// Calculates a user interface orientation based on an input orientation and provided affine transform
    /// - Parameters:
    ///   - orientation: the base orientation
    ///   - transform: the transform specified
    /// - Returns: the resulting orientation
    func orientation(from orientation: UIInterfaceOrientation, transform: CGAffineTransform)
        -> UIInterfaceOrientation
    {
        let conversionMatrix: [UIInterfaceOrientation] = [
            .portrait, .landscapeLeft, .portraitUpsideDown, .landscapeRight,
        ]
        guard let oldIndex = conversionMatrix.firstIndex(of: orientation), oldIndex != NSNotFound else {
            return .unknown
        }
        let rotationAngle = atan2(transform.b, transform.a)
        var newIndex = Int(oldIndex) - Int(round(rotationAngle / (.pi / 2)))
        while newIndex >= 4 {
            newIndex -= 4
        }
        while newIndex < 0 {
            newIndex += 4
        }
        return conversionMatrix[newIndex]
    }

    /// Determines the applicable AVCaptureVideoOrientation from a given UIInterfaceOrientation
    /// - Parameter interfaceOrientation: the interface orientation
    /// - Returns: the relevant AVCaptureVideoOrientation
    func videoOrientation(from interfaceOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch interfaceOrientation {
        case .portrait, .unknown: return .portrait
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        case .portraitUpsideDown: return .portraitUpsideDown
        @unknown default: return .portrait
        }
    }
}
