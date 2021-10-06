#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'pinch'
  s.version          = '1.6.0'
  s.summary          = 'PinchSDK'
  s.description      = <<-DESC
  The PinchSDK is used to collect the neccessary data for allowing you to gain actionable insights through real-time location and behavioural data.
                       DESC
  s.homepage         = 'https://developers.pinch.no'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'fluxLoop AS' => 'support@fluxloop.no' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.dependency 'PinchSDK', '2.2.0'

  s.ios.deployment_target = '9.0'
end

