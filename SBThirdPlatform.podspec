Pod::Spec.new do |s|

  s.name         = "SBThirdPlatform"
  s.version      = "0.3.0"
  s.summary      = "a swift third-platform components"
  s.description  = <<-DESC
       一个swift的基础库，包括BaseScene, BaseProfile, BaseInput etc.
                   DESC

  s.homepage     = "https://github.com/iFindTA/"
  s.license      = "MIT"
  s.author       = { "nanhu" => "nanhujiaju@gmail.com" }
  s.platform     = :ios,'10.0'
  s.source       = { :git => "https://github.com/iFindTA/SBSwiftComponents.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '10.0'
  s.source_files = "SBSwiftComponents/SBTPlatform/*.swift", "SBSwiftComponents/SBTPlatform/Vendors/**/*"
  s.resources = "SBSwiftComponents/SBTPlatform/Assets/*.*"
  s.framework    = "UIKit","Foundation","CoreMotion"
  s.requires_arc = true
 
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
#  s.dependency 'WechatOpenSDK'
#  s.dependency 'TencentOpenAPI'
  s.dependency 'SVProgressHUD'
  s.dependency 'AlamofireImage' 
  s.dependency 'SBComponents/Base'
  s.dependency 'SBComponents/Error'
  s.dependency 'SBComponents/Macros'
  s.dependency 'SBComponents/SceneRouter'
  
 # s.vendored_libraries = "libWeChatSDK.a"
  #s.vendored_frameworks = "Alipay.framework"

  s.static_framework = true
end
