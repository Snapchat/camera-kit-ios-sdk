//  Copyright Snap Inc. All rights reserved.

import AVFoundation
import AVKit
import SCSDKCameraKit
import UIKit

/// This is the default view that backs the CameraViewController.
open class CameraView: UIView {
    public enum PreviewRenderer: String, CaseIterable {
        case openGL = "OpenGL"
        case metal = "Metal"

        fileprivate func makePreviewView() -> PreviewRenderingView {
            switch self {
            case .openGL:
                return PreviewView()
            case .metal:
                return MetalPreviewView()
            }
        }
    }

    /// default camerakit view to draw outputted textures
    public let previewView: PreviewRenderingView

    // MARK: View properties

    /// bottom bar below carousel
    public let cameraBottomBar: CameraBottomBar = {
        let view = CameraBottomBar()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    public let hintLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.0
        label.font = .boldSystemFont(ofSize: 20.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    /// top label to show current selected lens
    public let lensLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = CameraElements.lensLabel.id
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    /// View used for ring light effect.
    public let ringLightView: RingLightView = {
        let view = RingLightView()
        view.accessibilityIdentifier = CameraElements.ringLightView.id
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    /// View that contains the buttons for various camera actions (flip, adjust, etc.)
    public let cameraActionsView: CameraActionsView = {
        let stackView = CameraActionsView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    /// Control view for switching between flash and ring light as well as controlling ring light color and intensity.
    public lazy var flashControlView: FlashControlView = {
        let view = FlashControlView()
        view.accessibilityIdentifier = CameraElements.flashControl.id
        view.accessibilityLabel = CameraKitLocalizedString(key: "camera_kit_flash_control", comment: "")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    /// Label shown beneath the ring light control that provides a hint regarding dismissing the control.
    public let flashControlDismissalHint: UILabel = {
        let label = UILabel.controlDismissalHint()
        label.accessibilityIdentifier = CameraElements.flashControlDismissalHint.id
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    /// Control view for tone map adjustment that allows the user to adjust the intensity of the tone map effect.
    public let toneMapControlView: AdjustmentControlView = {
        let view = AdjustmentControlView()
        view.accessibilityIdentifier = CameraElements.toneMapControl.id
        view.accessibilityLabel = CameraKitLocalizedString(key: "camera_kit_tone_map_control", comment: "")
        let variant = AdjustmentControlView.Variant.tone
        view.tag = variant.rawValue
        view.primaryLabel.text = variant.label
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    /// Label shown beneath the tone map control that provides a hint regarding dismissing the control.
    public let toneMapControlDismissalHintLabel: UILabel = {
        let label = UILabel.controlDismissalHint()
        label.accessibilityIdentifier = CameraElements.toneMapControlDismissalHint.id
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    /// Control view for portrait that allows the user to adjust the intensity of the portrait effect.
    public let portraitControlView: AdjustmentControlView = {
        let view = AdjustmentControlView()
        view.accessibilityIdentifier = CameraElements.portraitControl.id
        view.accessibilityLabel = CameraKitLocalizedString(key: "camera_kit_portrait_control", comment: "")
        let variant = AdjustmentControlView.Variant.portrait
        view.tag = variant.rawValue
        view.primaryLabel.text = variant.label
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    /// Label shown beneath the portrait control that provides a hint regarding dismissing the control.
    public let portraitControlDismissalHintLabel: UILabel = {
        let label = UILabel.controlDismissalHint()
        label.accessibilityIdentifier = CameraElements.portraitControlDismissalHint.id
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    /// carousel to scroll through lenses
    public let carouselView: CarouselView = {
        let view = CarouselView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// camera button to capture/record
    public let cameraButton: CameraButton = {
        let view = CameraButton()
        view.accessibilityIdentifier = CameraElements.cameraButton.id
        view.isAccessibilityElement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// media picker to allow using photos from camera roll in lenses
    public lazy var mediaPickerView: MediaPickerView = {
        let view = MediaPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// message view to show updates when selected lens changes
    public let messageView: MessageNotificationView = {
        let view = MessageNotificationView()
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public let snapAttributionView: SnapAttributionView = {
        let view = SnapAttributionView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    public let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        if #available(iOS 13, *) {
            view.style = .large
            view.color = .white
        } else {
            view.style = .whiteLarge
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public init(frame: CGRect, previewRenderer: PreviewRenderer) {
        self.previewView = previewRenderer.makePreviewView()
        print("[CameraKitSandbox] CameraView using \(previewRenderer.rawValue) preview renderer (\(type(of: previewView)))")
        super.init(frame: frame)
        setup()
    }

    override public convenience init(frame: CGRect) {
        self.init(frame: frame, previewRenderer: .metal)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        previewView.configureSafeArea(with: [carouselView, lensLabel])
        ringLightView.ringLightGradient.updateIntensity(
            to: CGFloat(flashControlView.ringLightIntensityValue), animated: false
        )
    }
}

// MARK: General View Setup

extension CameraView {
    private func setup() {
        setupPreview()
        setupRingLight()
        setupCameraBar()
        setupCameraActionsView()
        setupFlashButtons()
        setupToneMapButtons()
        setupPortraitButtons()
        setupHintLabel()
        setupLensLabel()
        setupCameraRing()
        setupCarousel()
        setupMediaPicker()
        setupMessageView()
        setupSnapAttributionView()
        setupActivityIndicator()
        setupFlashControlView()
        setupFlashControlDismissalHint()
        setupToneMapControlView()
        setupToneMapControlDismissalHintLabel()
        setupPortraitControlView()
        setupPortraitControlDismissalLabel()
    }

    private func setupPreview() {
        addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewView.topAnchor.constraint(equalTo: topAnchor),
            previewView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: Ring Light

extension CameraView {
    private func setupRingLight() {
        addSubview(ringLightView)
        NSLayoutConstraint.activate([
            ringLightView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ringLightView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ringLightView.topAnchor.constraint(equalTo: topAnchor),
            ringLightView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: Camera Bottom Bar

extension CameraView {
    private func setupCameraBar() {
        addSubview(cameraBottomBar)
        NSLayoutConstraint.activate([
            cameraBottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            cameraBottomBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            cameraBottomBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            cameraBottomBar.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }
}

// MARK: Camera Actions View

extension CameraView {
    private func setupCameraActionsView() {
        addSubview(cameraActionsView)
        NSLayoutConstraint.activate([
            cameraActionsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 6.0),
            cameraActionsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            cameraActionsView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}

// MARK: Lens Label

extension CameraView {
    private func setupLensLabel() {
        addSubview(lensLabel)
        NSLayoutConstraint.activate([
            lensLabel.centerYAnchor.constraint(equalTo: cameraActionsView.flipCameraButton.centerYAnchor),
            lensLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

// MARK: Carousel

extension CameraView {
    private func setupCarousel() {
        addSubview(carouselView)
        NSLayoutConstraint.activate([
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselView.centerYAnchor.constraint(equalTo: cameraButton.centerYAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 62.0),
        ])
    }
}

// MARK: Camera Ring

extension CameraView {
    private func setupCameraRing() {
        addSubview(cameraButton)
        NSLayoutConstraint.activate([
            cameraButton.bottomAnchor.constraint(equalTo: cameraBottomBar.topAnchor, constant: -28.0),
            cameraButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

// MARK: Media Picker

extension CameraView {
    private func setupMediaPicker() {
        addSubview(mediaPickerView)
        NSLayoutConstraint.activate([
            mediaPickerView.bottomAnchor.constraint(equalTo: cameraButton.topAnchor),
            mediaPickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mediaPickerView.widthAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.widthAnchor),
        ])
    }
}

// MARK: Messages

extension CameraView {
    private func setupMessageView() {
        addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: lensLabel.bottomAnchor, constant: 8.0),
            messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            messageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
        ])
    }

    public func showMessage(text: String, numberOfLines: Int, duration: TimeInterval = 1.5) {
        messageView.layer.removeAllAnimations()
        messageView.label.text = text
        messageView.label.numberOfLines = numberOfLines
        messageView.alpha = 0.0

        UIView.animate(
            withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState,
            animations: {
                self.messageView.alpha = 1.0
            }, completion: nil
        )

        // Do a dispatch here instead of a completion/animation delay because UI tests get confused
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            // Ensure we're dismissing the initial message and not a subsequent one that was shown before dispatch fired
            guard self.messageView.label.text == text else { return }
            UIView.animate(
                withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState,
                animations: {
                    self.messageView.alpha = 0.0
                }, completion: nil
            )
        }
    }
}

// MARK: Hint

extension CameraView {
    private func setupHintLabel() {
        addSubview(hintLabel)
        NSLayoutConstraint.activate([
            hintLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            hintLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

// MARK: Snap Attribution

extension CameraView {
    private func setupSnapAttributionView() {
        addSubview(snapAttributionView)
        NSLayoutConstraint.activate([
            snapAttributionView.topAnchor.constraint(equalTo: cameraBottomBar.topAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: snapAttributionView.trailingAnchor, multiplier: 2.0),
        ])
    }
}

// MARK: Activity Indicator

public extension CameraView {
    func setupActivityIndicator() {
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

// MARK: Flash

extension CameraView {
    private func setupFlashControlView() {
        addSubview(flashControlView)
        NSLayoutConstraint.activate([
            cameraActionsView.flashActionView.toggleButton.leadingAnchor.constraint(
                equalTo: flashControlView.trailingAnchor,
                constant: 8.0
            ),
            flashControlView.topAnchor.constraint(
                equalTo: cameraActionsView.flashActionView.toggleButton.bottomAnchor),
        ])
    }

    private func setupFlashControlDismissalHint() {
        addSubview(flashControlDismissalHint)
        NSLayoutConstraint.activate([
            flashControlDismissalHint.leadingAnchor.constraint(equalTo: flashControlView.leadingAnchor),
            flashControlDismissalHint.trailingAnchor.constraint(equalTo: flashControlView.trailingAnchor),
            flashControlDismissalHint.topAnchor.constraint(equalTo: flashControlView.bottomAnchor),
        ])
    }

    private func setupFlashButtons() {
        cameraActionsView.flashActionView.showActionSettings = { [weak self] in
            self?.hideAllControls()
            self?.flashControlView.isHidden = false
            self?.flashControlDismissalHint.isHidden = false
        }

        cameraActionsView.flashActionView.hideActionSettings = { [weak self] in
            self?.flashControlView.isHidden = true
            self?.flashControlDismissalHint.isHidden = true
        }

        cameraActionsView.flashActionView.toggleActionSettingsVisibility = { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.flashControlView.isHidden {
                strongSelf.hideAllControls()
            }
            strongSelf.flashControlView.isHidden.toggle()
            strongSelf.flashControlDismissalHint.isHidden.toggle()
        }
    }
}

// MARK: Tone Map

extension CameraView {
    private func setupToneMapControlView() {
        addSubview(toneMapControlView)
        NSLayoutConstraint.activate([
            toneMapControlView.trailingAnchor.constraint(
                equalTo: cameraActionsView.toneMapActionView.toggleButton.leadingAnchor, constant: -8.0
            ),
            toneMapControlView.topAnchor.constraint(
                equalTo: cameraActionsView.toneMapActionView.toggleButton.bottomAnchor),
        ])
    }

    private func setupToneMapControlDismissalHintLabel() {
        addSubview(toneMapControlDismissalHintLabel)
        NSLayoutConstraint.activate([
            toneMapControlDismissalHintLabel.leadingAnchor.constraint(equalTo: toneMapControlView.leadingAnchor),
            toneMapControlDismissalHintLabel.trailingAnchor.constraint(equalTo: toneMapControlView.trailingAnchor),
            toneMapControlDismissalHintLabel.topAnchor.constraint(equalTo: toneMapControlView.bottomAnchor),
        ])
    }

    private func setupToneMapButtons() {
        cameraActionsView.toneMapActionView.showActionSettings = { [weak self] in
            self?.hideAllControls()
            self?.toneMapControlView.isHidden = false
            self?.toneMapControlDismissalHintLabel.isHidden = false
        }

        cameraActionsView.toneMapActionView.hideActionSettings = { [weak self] in
            self?.toneMapControlView.isHidden = true
            self?.toneMapControlDismissalHintLabel.isHidden = true
        }

        cameraActionsView.toneMapActionView.toggleActionSettingsVisibility = { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.toneMapControlView.isHidden {
                strongSelf.hideAllControls()
            }
            strongSelf.toneMapControlView.isHidden.toggle()
            strongSelf.toneMapControlDismissalHintLabel.isHidden.toggle()
        }
    }
}

// MARK: Portrait

extension CameraView {
    private func setupPortraitControlView() {
        addSubview(portraitControlView)
        NSLayoutConstraint.activate([
            portraitControlView.trailingAnchor.constraint(
                equalTo: cameraActionsView.portraitActionView.toggleButton.leadingAnchor, constant: -8.0
            ),
            portraitControlView.topAnchor.constraint(
                equalTo: cameraActionsView.portraitActionView.toggleButton.bottomAnchor
            ),
        ])
    }

    private func setupPortraitControlDismissalLabel() {
        addSubview(portraitControlDismissalHintLabel)
        NSLayoutConstraint.activate([
            portraitControlDismissalHintLabel.leadingAnchor.constraint(equalTo: portraitControlView.leadingAnchor),
            portraitControlDismissalHintLabel.trailingAnchor.constraint(equalTo: portraitControlView.trailingAnchor),
            portraitControlDismissalHintLabel.topAnchor.constraint(equalTo: portraitControlView.bottomAnchor),
        ])
    }

    private func setupPortraitButtons() {
        cameraActionsView.portraitActionView.showActionSettings = { [weak self] in
            self?.hideAllControls()
            self?.portraitControlView.isHidden = false
            self?.portraitControlDismissalHintLabel.isHidden = false
        }

        cameraActionsView.portraitActionView.hideActionSettings = { [weak self] in
            self?.portraitControlView.isHidden = true
            self?.portraitControlDismissalHintLabel.isHidden = true
        }

        cameraActionsView.portraitActionView.toggleActionSettingsVisibility = { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.portraitControlView.isHidden {
                strongSelf.hideAllControls()
            }
            strongSelf.portraitControlView.isHidden.toggle()
            strongSelf.portraitControlDismissalHintLabel.isHidden.toggle()
        }
    }
}

// MARK: Camera Actions Control Helper

public extension CameraView {
    var isAnyControlVisible: Bool {
        ![
            flashControlView,
            flashControlDismissalHint,
            toneMapControlView,
            toneMapControlDismissalHintLabel,
            portraitControlView,
            portraitControlDismissalHintLabel,
        ].allSatisfy(\.isHidden)
    }

    func hideAllControls() {
        for view in [
            flashControlView,
            flashControlDismissalHint,
            toneMapControlView,
            toneMapControlDismissalHintLabel,
            portraitControlView,
            portraitControlDismissalHintLabel,
        ] {
            view.isHidden = true
        }
    }
}

// MARK: Tap to Focus

public extension CameraView {
    func drawTapAnimationView(at point: CGPoint) {
        let view = TapAnimationView(center: point)
        addSubview(view)

        view.show()
    }
}
