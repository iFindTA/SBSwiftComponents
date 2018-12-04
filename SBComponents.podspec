Pod::Spec.new do |s|

  s.name         = "SBComponents"
  s.version      = "0.6.1"
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
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
  #s.dependency 

  s.subspec 'DB' do |d|
    d.source_files = "SBSwiftComponents/SBDB/*.swift"
    d.dependency 'SQLite.swift'
    d.dependency 'SBComponents/Kit'
  end
  
  s.subspec 'Kit' do |k|
    k.source_files = "SBSwiftComponents/SBKit/*.swift"
    k.dependency 'SBToaster'
    k.dependency 'SBComponents/Base'
    k.dependency 'SBComponents/Error'
  end

 # s.subspec 'RSA' do |rsa|
 #   rsa.source_files = "SBSwiftComponents/SBRSA/*.swift"
 #   rsa.framework = "Security", "CommonCrypto"
 # end
 
 s.subspec 'Hud' do |hd|
    hd.source_files = "SBComponents/SBHud/*.swift"
    hd.dependency 'SBComponents/Macros'
  end

  s.subspec 'Base' do |b|
    b.source_files = "SBSwiftComponents/SBBase/*.swift"
    b.dependency 'SBComponents/HTTPRouter'
    b.dependency 'PPBadgeViewSwift'
  end

  s.subspec 'Error' do |r|
    r.source_files = "SBSwiftComponents/SBError/*.swift"
  end

  s.subspec 'Macros' do |m|
    m.source_files = "SBSwiftComponents/SBMacros/*.swift"
    m.dependency 'SBComponents/Error'
    m.dependency 'SBComponents/Extension'
  end

  s.subspec 'Cordova' do |c|
    c.source_files = "SBSwiftComponents/SBCordova/*.swift"
    c.dependency 'Cordova'
    c.dependency 'SSZipArchive'
    c.dependency 'SBComponents/Kit'
    c.dependency 'SBComponents/SceneRouter'
  end

  s.subspec 'Extension' do |e|
    e.source_files = "SBSwiftComponents/SBExtension/*.swift"
    e.dependency 'SnapKit'
  end

  s.subspec 'HTTPState' do |st|
    st.source_files = "SBSwiftComponents/SBHTTPState/*.swift"
    st.dependency 'RealReachability'
    st.dependency 'SBComponents/Macros'
  end

  s.subspec 'HTTPRouter' do |h|
    h.source_files = "SBSwiftComponents/SBHTTPRouter/*.swift"
    h.dependency 'Alamofire'
    h.dependency 'SwiftyJSON'
    h.dependency 'SBComponents/Hud'
    h.dependency 'SBComponents/Error'
    h.dependency 'SBComponents/Macros'
  end

  s.subspec 'SceneRouter' do |s|
    s.source_files = "SBSwiftComponents/SBSceneRouter/*.swift"
    s.resources = "SBSwiftComponents/SBSceneRouter/Assets/*.*"
    s.dependency 'SBComponents/Base'
    s.dependency 'SBComponents/Error'
    s.dependency 'SBComponents/Macros'
    #s.dependency 'SJNavigationPopGesture'
  end

  s.subspec 'TCPServer' do |t|
    t.source_files = "SBSwiftComponents/SBTCPServer/*.swift"
    t.dependency 'CocoaAsyncSocket'
    t.dependency 'SBComponents/Error'
  end

end
