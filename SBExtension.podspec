Pod::Spec.new do |s|

  s.name         = "SBExtension"
  s.version      = "0.0.2"
  s.summary      = "a swift extension kit"
  s.description  = <<-DESC
       一个swift的扩展库，包括UIImage, UIDevice, UIInput etc.
                   DESC
  #仓库主页
  s.homepage     = "https://github.com/iFindTA/"
  s.license      = "MIT"
  s.author       = { "nanhu" => "nanhujiaju@gmail.com" }
  s.platform     = :ios,'9.0'
  #仓库地址（注意下tag号）
  s.source       = { :git => "https://github.com/iFindTA/SBSwiftComponents.git", :tag => "#{s.version}" }
  #这里路径必须正确，因为swift只有一个文件不需要s.public_header_files
  #s.public_header_files = "Classes/*.h"
  s.source_files = "SBSwiftComponents/SBExtension/*.swift"
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
  s.dependency 'SnapKit', '~> 4.0.0'
end
