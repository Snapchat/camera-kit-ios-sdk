//  Copyright Snap Inc. All rights reserved.
//  SCSDKCameraKitReferenceUI

import UIKit

/// View to use for camera actions that can be enabled/disabled and configured via separate buttons.
public class CameraConfigurableActionView: UIView {
    // MARK: - Public

    /// Whether or not the action is currently configurable via a control view.
    /// If this is false, then the action can only be toggled on/off.
    public var configurable = true {
        didSet {
            if !configurable {
                collapse()
                hideActionSettings?()
            } else if toggleButton.isSelected {
                expand()
            }
        }
    }

    // MARK: Views

    /// Button used to enable/disable camera action.
    /// By default, this button has no image and it should be set.
    public lazy var toggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(toggleButtonTapped(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    /// Button used to open/close the settings for the camera action.
    /// By default, this button has no image and it should be set.
    public lazy var configurationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(configurationButtonTapped(sender:)), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    /// View that provides the stack view with its blurred background.
    public let blurEffectView: UIVisualEffectView = {
        let blurEffect: UIBlurEffect
        blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)

        let view = UIVisualEffectView(effect: blurEffect)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true

        return view
    }()

    /// Stack view used to arrange the view's two buttons.
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [toggleButton, configurationButton])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    // MARK: View Configuration

    // Hide the configuration button for the action, along with the blurred background.
    public func collapse() {
        configurationButton.isHidden = true
        blurEffectView.isHidden = true
    }

    // Show the configuration button for the action, along with the blurred background.
    public func expand() {
        configurationButton.isHidden = false
        blurEffectView.isHidden = false
    }

    // MARK: Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        toggleButton.applyCameraActionButtonShadow()
        configurationButton.applyCameraActionButtonShadow()
    }

    // MARK: - Private

    // MARK: Callbacks

    /// Callback to enable the camera action when the toggle button is selected.
    public var enableAction: (() -> Void)?

    /// Callback to disable the camera action when the toggle button is deselected.
    public var disableAction: (() -> Void)?

    /// Callback to show the settings for the camera action.
    public var showActionSettings: (() -> Void)?

    /// Callback to hide the settings for the camera action.
    public var hideActionSettings: (() -> Void)?

    /// Callback to toggle the visibility of the settings for the camera action.
    public var toggleActionSettingsVisibility: (() -> Void)?

    // MARK: Button Touch Handlers

    /// Toggles the selected state of the toggle button and hides/shows the configuration button and blurred background as appropriate.
    /// Depending on the post-toggle `isSelected` state of the toggle button, enables/disables the camera action and shows/hides
    /// the action's configuration view.
    /// - Parameter sender: The toggle button.
    @objc
    private func toggleButtonTapped(sender: UIButton) {
        sender.isSelected.toggle()
        configurationButton.isHidden = !sender.isSelected || !configurable
        blurEffectView.isHidden = !sender.isSelected || !configurable
        if sender.isSelected {
            enableAction?()
            if configurable {
                showActionSettings?()
            }
        } else {
            disableAction?()
            hideActionSettings?()
        }
    }

    /// Toggles the selected state of the configuration button and the visibility of the camera action's configuration view.
    /// - Parameter sender: The configuration button.
    @objc
    private func configurationButtonTapped(sender: UIButton) {
        sender.isSelected.toggle()
        toggleActionSettingsVisibility?()
    }
}

// MARK: General View Setup

extension CameraConfigurableActionView {
    private func commonInit() {
        layer.cornerRadius = 20
        setupBlurEffect()
        setupButtonStack()
    }
}

// MARK: Blur Effect

extension CameraConfigurableActionView {
    private func setupBlurEffect() {
        addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: Button Stack

extension CameraConfigurableActionView {
    private func setupButtonStack() {
        addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        for subview in buttonStackView.arrangedSubviews {
            NSLayoutConstraint.activate([
                subview.widthAnchor.constraint(equalToConstant: 40),
                subview.heightAnchor.constraint(equalToConstant: 40),
            ])
        }
    }
}
