Pod::Spec.new do |s|

  s.name         = "SBComponents"
  s.version      = "0.1.3"
  s.summary      = "a swift base components"
  s.description  = <<-DESC
       一个swift的基础库，包括BaseScene, BaseProfile, BaseInput etc.
                   DESC

  s.homepage     = "https://github.com/iFindTA/"
  s.license      = "MIT"
  s.author       = { "nanhu" => "nanhujiaju@gmail.com" }
  s.platform     = :ios,'9.0'
  s.source       = { :git => "https://github.com/iFindTA/SBSwiftComponents.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '9.0'
  #s.source_files = "SBSwiftComponents/SBBase/*.swift","SBSwiftComponents/SBExtension/*.swift"
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
  #s.dependency 'SBExtension', '~> 0.0.2'

  s.subspec 'DB' do |d|
    d.source_files = "SBComponents/SBDB/*.swift"
    d.dependency 'SQLite.swift'
    d.dependency 'SBComponents/Kit'
  end
  
  s.subspec 'Kit' do |k|
    k.source_files = "SBSwiftComponents/SBKit/*.swift"
    k.dependency 'Toaster'
    k.dependency 'SBComponents/Macros'
  end

  s.subspec 'Base' do |b|
    b.source_files = "SBSwiftComponents/SBBase/*.swift"
    b.dependency 'SBComponents/Macros'
    b.dependency 'SBComponents/Extension'
  end

  s.subspec 'Error' do |r|
    r.source_files = "SBSwiftComponents/SBError/*.swift"
  end

  s.subspec 'Macros' do |m|
    m.source_files = "SBSwiftComponents/SBMacros/*.swift"
    m.dependency 'SBComponents/Extension'
  end

  s.subspec 'Empty' do |p|
    p.source_files = "SBSwiftComponents/SBEmpty/*.swift"
    p.dependency 'DZNEmptyDataSet'
  end

  s.subspec 'Cordova' do |c|
    c.source_files = "SBSwiftComponents/SBCordova/*.swift"
    c.dependency 'Cordova'
    c.dependency 'SSZipArchive'
    c.dependency 'SBComponents/Kit'
    c.dependency 'SBComponents/Base'
  end

  s.subspec 'Extension' do |e|
    e.source_files = "SBSwiftComponents/SBExtension/*.swift"
    e.dependency 'SnapKit'
  end

  s.subspec 'HTTPRouter' do |h|
    h.source_files = "SBSwiftComponents/SBHTTPRouter/*.swift"
    h.dependency 'Alamofire'
    h.dependency 'SwiftyJSON'
    h.dependency 'SVProgressHUD'
    h.dependency 'RealReachability'
    h.dependency 'SBComponents/Error'
    h.dependency 'SBComponents/Macros'
  end
  
  s.subspec 'SceneRouter' do |s|
    s.source_files = "SBSwiftComponents/SBSceneRouter/*.swift"
    s.dependency 'SBComponents/Base'
    s.dependency 'SBComponents/Error'
    s.dependency 'SBComponents/Macros'
  end
end
