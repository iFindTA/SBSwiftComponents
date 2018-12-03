Pod::Spec.new do |s|

  s.name         = "SBUIComponents"
  s.version      = "0.5.8"
  s.summary      = "a swift base ui components"
  s.description  = <<-DESC
       一个swift的UI基础库，包括BaseScene, BaseProfile, BaseInput etc.
                   DESC

  s.homepage     = "https://github.com/iFindTA/"
  s.license      = "MIT"
  s.author       = { "nanhu" => "nanhujiaju@gmail.com" }
  s.platform     = :ios,'10.0'
  s.source       = { :git => "https://github.com/iFindTA/SBSwiftComponents.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '10.0'
  #s.source_files = "SBSwiftComponents/*/*.swift"
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
  #s.dependency 

  ## custom uis
  s.subspec 'Panel' do |pn|
    pn.source_files = "SBSwiftComponents/SBPanels/*.swift"
    pn.dependency 'SBComponents/Base'
    pn.dependency 'DTCoreText'
    pn.dependency 'SDWebImage/Core'
  end

  s.subspec 'Scenes' do |ss|
    ss.source_files = "SBSwiftComponents/SBScenes/*.swift"
    ss.resources = "SBSwiftComponents/SBScenes/Assets/*.*"
    ss.dependency 'SBComponents/Kit'
    ss.dependency 'SDWebImage/Core'
  end

  s.subspec 'Banner' do |bn|
  	bn.source_files = "SBSwiftComponents/SBBanner/*.swift"
  	bn.dependency 'FSPagerView'
  	bn.dependency 'SDWebImage/Core'
  	bn.dependency 'CHIPageControl/Jaloro'
  	bn.dependency 'SBComponents/Macros'
  end

  s.subspec 'Scan' do |q|
    q.source_files = "SBSwiftComponents/SBScan/*.swift"
    q.resources = "SBSwiftComponents/SBScan/Assets/*.*"
    q.framework = "CoreGraphics", "AVFoundation"
    q.dependency 'SBComponents/Kit'
    q.dependency 'SBComponents/SceneRouter'
  end

  s.subspec 'Empty' do |p|
    p.source_files = "SBSwiftComponents/SBEmpty/*.swift"
    p.resources = "SBSwiftComponents/SBEmpty/Assets/*.*"
    p.dependency 'DZNEmptyDataSet'
    p.dependency 'SBComponents/Base'
    p.dependency 'SBComponents/HTTPState'
  end

  s.subspec 'WebBrowser' do |w|
    w.source_files = "SBSwiftComponents/SBBrowser/*.swift"
    w.resources = "SBSwiftComponents/SBBrowser/Assets/*.*"
    w.framework = "WebKit"
    w.dependency 'SBComponents/Kit'
    w.dependency 'SBComponents/Base'
    w.dependency 'SBComponents/SceneRouter'
  end

  s.subspec 'Navigator' do |n|
  	n.source_files = "SBSwiftComponents/SBNavigator/*.swift"
  	n.dependency 'SBComponents/Base'
  	n.dependency 'SBComponents/Macros'
  end

  s.subspec 'AudioIndicator' do |a|
    a.source_files = "SBSwiftComponents/SBAudioIndicator/*.swift"
    a.dependency 'SBComponents/Macros'
  end

end