#
# Be sure to run `pod lib lint WQFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WQFramework'
  s.version          = '0.1.0'
  s.summary          = 'A short description of WQFramework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jayla25349/WQFramework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jayla25349' => 'jayla25349@gmail.com' }
  s.source           = { :git => 'https://github.com/jayla25349/WQFramework.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WQFramework/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WQFramework' => ['WQFramework/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.prefix_header_file = 'WQFramework/Classes/WQFramework.h'
  s.frameworks = 'UIKit', 'Foundation'
s.dependency 'CocoaLumberjack'
s.dependency 'AFNetworking'
s.dependency 'YYCategories'
s.dependency 'YYCache'
s.dependency 'SVProgressHUD'
s.dependency 'MJRefresh'
s.dependency 'Masonry'
end
