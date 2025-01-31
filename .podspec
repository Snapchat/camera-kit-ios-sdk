Pod::Spec.new do |s|
    s.name             = 'SCSDKCameraKit'
    s.version          = '1.37.0'
    s.summary          = 'Snap Camera Kit SDK for iOS.'
    s.description      = 'Snap Camera Kit SDK for iOS, used for integrating Snap camera functionality into iOS apps.'
    s.homepage         = 'https://github.com/Pixus-Inc/camera-kit-ios-sdk'
    s.source           = { :git => 'https://github.com/Pixus-Inc/camera-kit-ios-sdk.git', :tag => '1.37.0' }
    s.platform         = :ios, '12.0'
    s.source_files     = 'SCSDKCameraKit/Classes/**/*.{h,m,swift}'
    s.requires_arc     = true
  end