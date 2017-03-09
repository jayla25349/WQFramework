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
  
  s.default_subspecs = 'Core', 'Config'
  
  s.subspec 'Core' do |core|
      core.source_files = 'WQFramework/Classes/Core/**/*'
      core.frameworks = 'UIKit', 'Foundation'
      
      core.dependency 'CocoaLumberjack'
      core.dependency 'YYCategories'
      core.dependency 'YYCache'
      
      core.dependency 'SVProgressHUD'
      core.dependency 'MJRefresh'
      core.dependency 'Masonry'
  end
  
  s.subspec 'Network' do |network|
      network.source_files = 'WQFramework/Classes/Network/**/*'
      
      network.dependency 'AFNetworking'
  end
  
#  s.subspec 'Share' do |share|
#      share.source_files = 'WQFramework/Classes/Share/**/*'
#      
#      share.dependency 'ShareSDK3'
#      share.dependency 'ShareSDK3/ShareSDK'
#      share.dependency 'ShareSDK3/ShareSDKPlatforms/QQ'
#      share.dependency 'ShareSDK3/ShareSDKPlatforms/WeChat'
#      share.dependency 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
#      share.dependency 'MOBFoundation'
#  end
  
  s.subspec 'Theme' do |theme|
      theme.source_files = 'WQFramework/Classes/Theme/**/*'
      
      theme.dependency 'Config'
  end
  
  s.subspec 'User' do |user|
      user.source_files = 'WQFramework/Classes/User/**/*'
  end
end
