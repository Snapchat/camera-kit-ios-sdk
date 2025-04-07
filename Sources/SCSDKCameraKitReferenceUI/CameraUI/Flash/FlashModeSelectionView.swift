//  Copyright Snap Inc. All rights reserved.
//  SCSDKCameraKitReferenceUI

import Foundation
import UIKit

public protocol FlashModeSelectionViewDelegate: AnyObject {
    /// Notifies the delegate that there is an update to the selected flash mode.
    /// - Parameters:
    ///    - view: The flash mode selection view.
    ///    - updatedFlashMode: The updated flash mode selection.
    func flashModeSelectionView(_ view: FlashModeSelectionView, updatedMode mode: CameraController.FlashMode)
}

public class FlashModeSelectionView: UIView {
    /// Delegate for handling update's to the selected flash mode in the view.
    public weak var delegate: FlashModeSelectionViewDelegate?

    /// The current FlashMode that is selected in the view.
    public var flashMode: CameraController.FlashMode {
        set {
            segmentedControl.selectedSegmentIndex = newValue.rawValue
        }
        get {
            CameraController.FlashMode(rawValue: segmentedControl.selectedSegmentIndex) ?? .standard
        }
    }

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            CameraKitLocalizedString(key: "camera_kit_standard", comment: ""),
            CameraKitLocalizedString(key: "camera_kit_ring", comment: ""),
        ])

        control.accessibilityIdentifier = FlashControlElements.flashModeSelector.id
        control.addTarget(self, action: #selector(flashModeChanged), for: .valueChanged)

        control.tintColor = .clear
        control.backgroundColor = .clear
        control.apportionsSegmentWidthsByContent = true
        let rect = CGRect(x: 0.0, y: 0.0, width: 1, height: 27)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        control.setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        control.setBackgroundImage(image, for: .normal, barMetrics: .default)

        let imageSize = CGSize(width: 3, height: 27)
        let underlineSize = CGSize(width: 3, height: 3)
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let selImage = renderer.image(actions: { context in
            UIColor(hex: 0xFFFC00).setFill()
            UIRectFill(
                CGRect(
                    x: 0, y: imageSize.height - underlineSize.height, width: underlineSize.width,
                    height: underlineSize.height
                ))
        })
        control.setBackgroundImage(selImage, for: .selected, barMetrics: .default)

        let defaultAttributes = [
            NSAttributedString.Key.font: UIFont.sc_demiBoldFont(size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
        ]
        control.setTitleTextAttributes(defaultAttributes, for: .normal)
        let selectedAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(hex: 0xFFFC00),
        ]
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.layer.maskedCorners = .init()

        return control
    }()

    @objc
    private func flashModeChanged(_ sender: UISegmentedControl) {
        if let flashMode = CameraController.FlashMode(rawValue: sender.selectedSegmentIndex) {
            delegate?.flashModeSelectionView(self, updatedMode: flashMode)
        }
    }

    // MARK: Init

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
}

// MARK: View Setup

extension FlashModeSelectionView {
    private func commonInit() {
        addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
