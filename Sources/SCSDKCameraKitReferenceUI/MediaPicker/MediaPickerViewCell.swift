//  Copyright Snap Inc. All rights reserved.
//  CameraKit

import UIKit

/// Collection view sell that is used to represent a media picker view asset
class MediaPickerViewAssetCell: UICollectionViewCell {
    let imageView = UIImageView()
    let loadingIndiciator = UIActivityIndicatorView()
    let durationLabel = UILabel()
    let selectionMask = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.layer.cornerCurve = .continuous
        durationLabel.textColor = .white
        durationLabel.font = UIFont.boldSystemFont(ofSize: 10)
        contentView.addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            durationLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 3),
            contentView.bottomAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 3),
        ])
        selectionMask.backgroundColor = .clear
        selectionMask.layer.borderWidth = 3
        selectionMask.layer.borderColor = UIColor.purple.cgColor
        selectionMask.layer.cornerRadius = imageView.layer.cornerRadius
        selectionMask.layer.cornerCurve = imageView.layer.cornerCurve
        selectionMask.isHidden = true
        contentView.addSubview(selectionMask)
        selectionMask.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            imageView.leadingAnchor.constraint(equalTo: selectionMask.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: selectionMask.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: selectionMask.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: selectionMask.topAnchor),
        ])
        contentView.addSubview(loadingIndiciator)
        loadingIndiciator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            contentView.centerXAnchor.constraint(equalTo: loadingIndiciator.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: loadingIndiciator.centerYAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
