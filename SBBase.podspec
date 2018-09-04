Pod::Spec.new do |s|

  s.name         = "SBBase"
  s.version      = "0.0.5"
  s.summary      = "a swift base kit"
  s.description  = <<-DESC
       一个swift的基础库，包括BaseScene, BaseProfile, BaseInput etc.
                   DESC
  #仓库主页
  s.homepage     = "https://github.com/iFindTA/"
  s.license      = "MIT"
  s.author       = { "nanhu" => "nanhujiaju@gmail.com" }
  s.platform     = :ios,'9.0'
  s.source       = { :git => "https://github.com/iFindTA/SBSwiftComponents.git", :tag => "#{s.version}" }
  
  #s.public_header_files = "Classes/*.h"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
  s.source_files = "SBSwiftComponents/SBBase/*.swift"
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
  s.dependency 'SBExtension', '~> 0.0.2'
end
