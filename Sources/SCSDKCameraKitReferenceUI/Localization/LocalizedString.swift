//  Copyright Snap Inc. All rights reserved.
//  CameraKit

import UIKit

@objc(SCCameraKitReferenceUILocalizationBundleStub) class Stub: NSObject {}

/// Objective-C interface for CameraKitLocalizedString
/// - Parameters:
///   - key: key to lookup.
///   - bundle: explicit bundle to look up key for. If omitted, uses the CameraKit Reference UI bundle.
///   - preferredLanguages: a list of language codes in order of preference.
///   - comment: any comments on the string.
///   - table: an explicit strings table to reference.
/// - Returns: a localized string, if one is available for the languages specified, otherwise the English string (and the key, if neither are found).
@objc
public extension NSString {
    @objc
    class func cameraKit_localized(
        key: String,
        bundle: Bundle?,
        preferredLanguages: [String] = NSLocale.preferredLanguages,
        comment: String?,
        table: String? = nil
    ) -> String {
        CameraKitLocalizedString(
            key: key, bundle: bundle, preferredLanguages: preferredLanguages, comment: comment, table: table
        )
    }
}

/// Looks up a localized string for CameraKit's reference UI.
/// - Parameters:
///   - key: key to lookup.
///   - bundle: explicit bundle to look up key for. If omitted, uses the CameraKit Reference UI bundle.
///   - preferredLanguages: a list of language codes in order of preference.
///   - comment: any comments on the string.
///   - table: an explicit strings table to reference.
/// - Returns: a localized string, if one is available for the languages specified, otherwise the English string (and the key, if neither are found).
public func CameraKitLocalizedString(
    key: String,
    bundle: Bundle? = nil,
    preferredLanguages: [String] = NSLocale.preferredLanguages,
    comment: String?,
    table: String? = nil
) -> String {
    let resolvedBundle = bundle ?? bestBundle(forPreferredLanguages: preferredLanguages)
    let mainBundle = bundle ?? Bundle.main
    let fallbackBundle = bestBundle(forPreferredLanguages: ["en-US"])
    let mainBundleResolvedString = mainBundle.localizedString(forKey: key, value: nil, table: table)
    let resolvedString = resolvedBundle.localizedString(forKey: key, value: nil, table: table)
    let fallbackString = fallbackBundle.localizedString(forKey: key, value: nil, table: table)

    if mainBundleResolvedString != key {
        // The requested string has been localized in the main bundle.
        return mainBundleResolvedString
    }
    if resolvedString == key, fallbackString != key {
        // The localizedString call for the specified bundle returned the key (ie: it hasn't been localized) but the English bundle doesn't.
        // This indicates that the requested string has not been localized, and we should fall back to the English value instead of showing the user the key.
        return fallbackString
    }
    return resolvedString
}

private func bestBundle(forPreferredLanguages preferredLanguages: [String]) -> Bundle {
    preferredLanguages.lazy.compactMap(bestBundle(forPreferredLanguage:)).first ?? Bundle(for: Stub.self)
}

private func bestBundle(forPreferredLanguage preferredLanguage: String) -> Bundle? {
    let bundle: Bundle
    // CocoaPods places it here
    if let url = Bundle.main.url(forResource: "CameraKitReferenceUI", withExtension: "bundle"), let referenceBundle = Bundle(url: url) {
        bundle = referenceBundle
    } else {
        bundle = Bundle(for: Stub.self)
    }
    let lProjURL: URL?
    if let fullMatch = bundle.url(forResource: preferredLanguage, withExtension: Constants.lProjExtension) {
        lProjURL = fullMatch
    } else {
        // preferred language contains region code (ie. `es-US`) which may not have its own localization
        // so if not found, try to find localization for just the language code (ie. `es`)
        let components = NSLocale.components(fromLocaleIdentifier: preferredLanguage)
        if let languageCode = components[NSLocale.Key.languageCode.rawValue] {
            lProjURL = bundle.url(forResource: languageCode, withExtension: Constants.lProjExtension)
        } else {
            lProjURL = nil
        }
    }
    guard let lProjURL else {
        return nil
    }
    return Bundle(url: lProjURL)
}

private enum Constants {
    static let lProjExtension = "lproj"
}
