Pod::Spec.new do |s|

  s.name         = "SBComponents"
  s.version      = "0.3.3"
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
  #s.source_files = "SBSwiftComponents/*/*.swift"
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
    k.dependency 'Toaster'
    k.dependency 'SBComponents/Base'
    k.dependency 'SBComponents/Error'
  end

 # s.subspec 'RSA' do |rsa|
 #   rsa.source_files = "SBSwiftComponents/SBRSA/*.swift"
 #   rsa.framework = "Security", "CommonCrypto"
 # end

  s.subspec 'Base' do |b|
    b.source_files = "SBSwiftComponents/SBBase/*.swift"
    b.dependency 'SBComponents/Macros'
    b.dependency 'SBComponents/Extension'
    b.dependency 'ESPullToRefresh'
    b.dependency 'IQKeyboardManagerSwift'
    b.dependency 'GDPerformanceView-Swift'
  end

  s.subspec 'Scan' do |q|
    q.source_files = "SBSwiftComponents/SBScan/*.swift"
    q.resources = "SBSwiftComponents/SBScan/Assets/*.*"
    #q.ios.deployment_target = '10.0'
    q.framework = "CoreGraphics", "AVFoundation"
    q.dependency 'SBComponents/Kit'
    q.dependency 'SBComponents/SceneRouter'
  end

  s.subspec 'Error' do |r|
    r.source_files = "SBSwiftComponents/SBError/*.swift"
  end

  s.subspec 'Macros' do |m|
    m.source_files = "SBSwiftComponents/SBMacros/*.swift"
    m.dependency 'SBComponents/Error'
    m.dependency 'SBComponents/Extension'
  end

  s.subspec 'Empty' do |p|
    p.source_files = "SBSwiftComponents/SBEmpty/*.swift"
    p.resources = "SBSwiftComponents/SBEmpty/Assets/*.*"
    p.dependency 'DZNEmptyDataSet'
    p.dependency 'SBComponents/Macros'
    p.dependency 'SBComponents/HTTPState'
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
    h.dependency 'SVProgressHUD'
    h.dependency 'SBComponents/Error'
    h.dependency 'SBComponents/Macros'
  end

  s.subspec 'SceneRouter' do |s|
    s.source_files = "SBSwiftComponents/SBSceneRouter/*.swift"
    s.resources = "SBSwiftComponents/SBSceneRouter/Assets/*.*"
    s.dependency 'SBComponents/Base'
    s.dependency 'SBComponents/Error'
    s.dependency 'SBComponents/Macros'
    s.dependency 'SJNavigationPopGesture'
  end

  s.subspec 'WebBrowser' do |w|
    w.source_files = "SBSwiftComponents/SBBrowser/*.swift"
    w.resources = "SBSwiftComponents/SBBrowser/Assets/*.*"
    w.framework = "WebKit"
    w.dependency 'SBComponents/Kit'
    w.dependency 'SBComponents/Base'
    w.dependency 'SBComponents/SceneRouter'
  end

  s.subspec 'TCPServer' do |t|
    t.source_files = "SBSwiftComponents/SBTCPServer/*.swift"
    t.dependency 'CocoaAsyncSocket'
    t.dependency 'SBComponents/Error'
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
