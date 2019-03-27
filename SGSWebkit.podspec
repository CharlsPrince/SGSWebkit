#
# Be sure to run `pod lib lint SGSWebkit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SGSWebkit'
  s.version          = '0.0.1'
  s.summary          = '网页加载器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
基于 WKWebKit 的网页加载器
                       DESC

  s.homepage         = 'https://github.com/CharlsPrince/SGSWebkit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CharlsPrince' => '961629701@qq.com' }
  s.source           = { :git => 'https://github.com/CharlsPrince/SGSWebkit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SGSWebkit/Classes/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'SGSWebkit' => ['SGSWebkit/Assets/*.png']
  # }

  s.public_header_files = 'SGSWebkit/Classes/**/*.{h}'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
