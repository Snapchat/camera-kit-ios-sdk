//  Copyright Snap Inc. All rights reserved.
//  SCSDKCameraKitReferenceUI

import UIKit

public protocol AdjustmentControlViewDelegate: AnyObject {
    /// Notifies the delegate that the control's intensity slider's value has changed.
    /// - Parameters:
    ///    - control: The control view.
    ///    - value: The updated value received from the control's intensity slider.
    func adjustmentControlView(_ control: AdjustmentControlView, sliderValueChanged value: Double)
}

public class AdjustmentControlView: UIView {
    /// Adjustments that can be controlled via this view.
    /// Used to set the tag field of the view so the delegate can disambiguate between different adjustments.
    public enum Variant: Int {
        case tone
        case portrait

        /// Text for the primary label of the control with the specified variant.
        public var label: String {
            switch self {
            case .tone: return CameraKitLocalizedString(key: "camera_kit_adjustment_tone", comment: "")
            case .portrait: return CameraKitLocalizedString(key: "camera_kit_adjustment_portrait", comment: "")
            }
        }
    }

    /// Delegate for handling changes to the adjustment intensity slider.
    public weak var delegate: AdjustmentControlViewDelegate?

    /// The intensity of the adjustment according to the control's slider's value.
    public var intensityValue: Float {
        get {
            intensitySlider.value
        }
        set {
            intensitySlider.setValue(newValue, animated: false)
        }
    }

    // MARK: Views

    /// View that provides the control with its blurred background.
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect: UIBlurEffect
        blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)

        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Primary label for the control.
    public let primaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.sc_demiBoldFont(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    /// Secondary label for the control.
    public let secondaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xFFFC00)
        label.font = UIFont.sc_demiBoldFont(size: 14)
        label.text = CameraKitLocalizedString(key: "camera_kit_adjustment_active", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    /// Slider to choose intensity of the adjustment.
    private lazy var intensitySlider: ControlSlider = {
        let slider = ControlSlider()
        slider.accessibilityLabel = CameraKitLocalizedString(key: "camera_kit_adjustment_intensity_slider", comment: "")
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.delegate = self
        return slider
    }()

    // MARK: Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupBlurEffectView()
        setupPrimaryLabel()
        setupSecondaryLabel()
        setupIntensitySlider()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: 168.0, height: UIView.noIntrinsicMetric)
    }
}

// MARK: Blur Effect

extension AdjustmentControlView {
    private func setupBlurEffectView() {
        addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: Primary Label

extension AdjustmentControlView {
    private func setupPrimaryLabel() {
        addSubview(primaryLabel)
        NSLayoutConstraint.activate([
            primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14.0),
            primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14.0),
            primaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            primaryLabel.heightAnchor.constraint(equalToConstant: 20.0),
        ])
    }
}

// MARK: Secondary Label

extension AdjustmentControlView {
    private func setupSecondaryLabel() {
        addSubview(secondaryLabel)
        NSLayoutConstraint.activate([
            secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.leadingAnchor),
            secondaryLabel.trailingAnchor.constraint(equalTo: primaryLabel.trailingAnchor),
            secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 4),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 20.0),
        ])
    }
}

// MARK: Intensity Slider

extension AdjustmentControlView {
    private func setupIntensitySlider() {
        addSubview(intensitySlider)
        NSLayoutConstraint.activate([
            intensitySlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            intensitySlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            intensitySlider.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 8.0),
            intensitySlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
        ])
    }
}

// MARK: Control Slider Delegate

extension AdjustmentControlView: ControlSliderDelegate {
    public func controlSlider(_ slider: ControlSlider, updatedValue value: Float, done: Bool) {
        delegate?.adjustmentControlView(self, sliderValueChanged: Double(value))
    }
}
