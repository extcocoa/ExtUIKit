#
# Be sure to run `pod lib lint ExtUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ExtUIKit'
  s.version          = '0.1.2'
  s.summary          = 'Extended UIKit for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An extended UIKit for iOS Dev.
                       DESC

  s.homepage         = 'https://github.com/extcocoa/ExtUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jessehao' => 'jeasygates@hotmail.com' }
  s.source           = { :git => 'https://github.com/extcocoa/ExtUIKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jeasyhg'

  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'

  s.source_files = 'ExtUIKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ExtUIKit' => ['ExtUIKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
