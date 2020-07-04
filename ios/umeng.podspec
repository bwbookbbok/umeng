#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint umeng.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'umeng'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  
  s.public_header_files = 'Classes/**/*.h'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  # 第三方framework
  s.dependency 'Flutter'
  # 友盟依赖
  s.dependency 'UMCCommon', '7.1.0'
#  s.dependency 'UMCAnalytics', '6.0.5'
  s.dependency 'UMCCommonLog'
  s.dependency 'UMCPush'
  
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  #s.swift_version = '5.0'
end
