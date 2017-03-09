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
  
  s.default_subspecs = 'Core', 'Network'
  
  s.subspec 'Core' do |core|
      core.source_files = 'WQFramework/Classes/Core/**/*'
      core.frameworks = 'UIKit', 'Foundation'
      
      core.dependency 'CocoaLumberjack'
      core.dependency 'Reachability'
      core.dependency 'YYCategories'
      
      core.dependency 'SVProgressHUD'
      core.dependency 'MJRefresh'
      core.dependency 'Masonry'
  end
  
  s.subspec 'Network' do |network|
      network.source_files = 'WQFramework/Classes/Network/**/*'
      
      network.dependency 'CocoaLumberjack'
      network.dependency 'YYCategories'
      network.dependency 'AFNetworking'
  end
end
