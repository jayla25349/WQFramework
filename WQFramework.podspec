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
  s.summary          = 'ios develop framework.'

  s.description      = <<-DESC
WQFramework is an ios develop framework.
                       DESC

  s.homepage         = 'https://github.com/jayla25349/WQFramework'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jayla25349' => 'jayla25349@gmail.com' }
  s.source           = { :git => 'https://github.com/jayla25349/WQFramework.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.pod_target_xcconfig    = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.source_files = 'WQFramework/Classes/**/*'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.resource_bundles = {
  #   'WQFramework' => ['WQFramework/Assets/*.png']
  # }

  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'CocoaLumberjack'
  s.dependency 'AFNetworking'
  s.dependency 'YYCategories'
  s.dependency 'YYCache'
  s.dependency 'SVProgressHUD'
  s.dependency 'MJRefresh'
  s.dependency 'Masonry'
end
