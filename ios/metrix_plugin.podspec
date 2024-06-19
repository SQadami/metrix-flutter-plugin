#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint metrix_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'metrix_plugin'
  s.version          = '1.4.0'
  s.summary          = 'Metrix Flutter plugin.'
  s.description      = <<-DESC
  Metrix Flutter plugin.
                       DESC
  s.homepage         = 'http://admetricx.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Metrix'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # MetrixFramework
  s.dependency 'Metrix/flutter', '2.1.0'
end
