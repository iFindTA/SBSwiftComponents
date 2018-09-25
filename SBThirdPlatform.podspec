Pod::Spec.new do |s|

  s.name         = "SBComponents"
  s.version      = "0.2.6"
  s.summary      = "a swift base components"
  s.description  = <<-DESC
       一个swift的基础库，包括BaseScene, BaseProfile, BaseInput etc.
                   DESC

  s.homepage     = "https://github.com/iFindTA/"
  s.license      = "MIT"
  s.author       = { "nanhu" => "nanhujiaju@gmail.com" }
  s.platform     = :ios,'10.0'
  s.source       = { :git => "https://github.com/iFindTA/SBSwiftComponents.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '10.0'
  s.source_files = "SBSwiftComponents/SBTPlatform/*.swift"
  s.resources = "SBSwiftComponents/SBTPlatform/Assets/*.*"
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
 
  s.dependency 'Alamofire'
  s.dependency 'WechatOpenSDK'
  s.dependency 'TencentOpenAPI'
  s.dependency 'SVProgressHUD'
  s.dependency 'AlamofireImage' 
  s.dependency 'SBComponents/Base'
  s.dependency 'SBComponents/Error'
  s.dependency 'SBComponents/Macros'

end
