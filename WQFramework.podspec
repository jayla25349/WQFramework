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
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  s.frameworks = 'UIKit', 'Foundation'
  
  s.subspec 'Core' do |core|
      core.source_files = 'WQFramework/Classes/Core/**/*'
      
      core.dependency 'CocoaLumberjack'
      core.dependency 'Reachability'
      core.dependency 'YYCategories'
  end
  
  s.subspec 'Foundation' do |foundation|
      foundation.dependency 'WQFramework/Core'
      
      foundation.subspec 'Directory' do |directory|
          directory.source_files = 'WQFramework/Classes/Foundation/Directory/**/*'
      end
      
      foundation.subspec 'Config' do |config|
          config.source_files = 'WQFramework/Classes/Foundation/Config/**/*'
      end
      
      foundation.subspec 'Theme' do |theme|
          theme.source_files = 'WQFramework/Classes/Foundation/Theme/**/*'
          theme.dependency 'WQFramework/Foundation/Config'
      end
      
      foundation.subspec 'Network' do |network|
          network.source_files = 'WQFramework/Classes/Foundation/Network/**/*'
          network.dependency 'AFNetworking'
      end
  end
  
  s.subspec 'UIKit' do |ui|
      ui.dependency 'WQFramework/Core'
      ui.dependency 'WQFramework/Foundation/Theme'
      ui.dependency 'Masonry'
      
      ui.subspec 'BlankView' do |blank|
          blank.source_files = 'WQFramework/Classes/UIKit/BlankView/**/*'
      end
      
      ui.subspec 'RefreshView' do |refresh|
          refresh.source_files = 'WQFramework/Classes/UIKit/RefreshView/**/*'
          refresh.dependency 'WQFramework/UIKit/BlankView'
          refresh.dependency 'SVProgressHUD'
          refresh.dependency 'MJRefresh'
      end
      
      ui.subspec 'FinderListVC' do |finder|
          finder.source_files = 'WQFramework/Classes/UIKit/FinderListVC/**/*'
          finder.dependency 'SVProgressHUD'
      end
      
      ui.subspec 'PlistListVC' do |plist|
          plist.source_files = 'WQFramework/Classes/UIKit/PlistListVC/**/*'
      end
  end
end
