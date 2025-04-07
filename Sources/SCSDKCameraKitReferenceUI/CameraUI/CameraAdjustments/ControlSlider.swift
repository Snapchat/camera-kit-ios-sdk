//  Copyright Snap Inc. All rights reserved.
//  SCSDKCameraKitReferenceUI

import UIKit

public protocol ControlSliderDelegate: AnyObject {
    /// Notifies the delegate that the slider's value has changed.
    /// - Parameters:
    ///    - slider: The control slider.
    ///    - updatedValue: The updated value received from the slider.
    ///    - done: Whether or not the slider's value is done changing.
    func controlSlider(_ slider: ControlSlider, updatedValue value: Float, done: Bool)
}

public class ControlSlider: UISlider {
    /// Delegate for handling updates to the slider's value.
    public weak var delegate: ControlSliderDelegate?

    /// Replacement image for slider thumb.
    private let thumbImage = UIImage(
        named: "ck_slider_thumb", in: BundleHelper.resourcesBundle, compatibleWith: nil
    )

    /// Gradient that serves as a replacement track for the slider.
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0, 0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.white.withAlphaComponent(0.1).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor,
        ]

        return gradient
    }()

    /// Updates the gradient track according to the value passed in.
    private func updateGradientTrack(with value: Float) {
        let thumbRect = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        let midpointLocation = Double(thumbRect.midX / bounds.width) as NSNumber
        gradient.locations = [midpointLocation, midpointLocation]
    }

    /// Updates the gradient track and calls the valueChanged delegate function.
    @objc
    private func sliderValueChanged(_ sender: UISlider, event: UIEvent) {
        let done = event.allTouches?.first?.phase == .ended
        updateGradientTrack(with: sender.value)
        delegate?.controlSlider(self, updatedValue: sender.value, done: done)
    }

    override public func setValue(_ value: Float, animated: Bool) {
        super.setValue(value, animated: animated)
        updateGradientTrack(with: value)
    }

    /// Sets the color of the slider's thumb.
    /// - Parameter color: The color to set for the the slider's thumb.
    public func setThumbColor(_ color: UIColor) {
        setThumbImage(thumbImage?.withTintColor(color), for: .normal)
    }

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white.withAlphaComponent(0.1)
        layer.insertSublayer(gradient, at: 0)
        setThumbImage(thumbImage, for: .normal)
        let blankImage = UIImage()
        setMinimumTrackImage(blankImage, for: .normal)
        setMaximumTrackImage(blankImage, for: .normal)

        addTarget(self, action: #selector(sliderValueChanged(_:event:)), for: .valueChanged)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 31)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer

        gradient.frame = bounds
    }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 47)
    }
}
