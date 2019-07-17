platform :ios, '9.0'

# hook for install
post_install do |installer|
  exTargets = ['DTCoreText', 'DTFoundation', 'ESPullToRefresh']
  installer.pods_project.targets.each do |target|
    if exTargets.include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end
end

use_frameworks!

target 'SBSwiftComponents' do
pod 'SnapKit', '~> 4.2.0'
pod 'Cordova', '~> 4.5.4'
pod 'SBToaster', '~> 2.1.2'
pod 'Alamofire', '~> 4.7.3'
pod 'SwiftyJSON', '~> 5.0.0'
pod 'SQLite.swift', '~> 0.11.5'
pod 'SSZipArchive', '~> 2.1.4'
pod 'SVProgressHUD', '~> 2.2.5'
pod 'DZNEmptyDataSet', '~> 1.8.1'
pod 'PPBadgeViewSwift', '~> 2.2.2'
pod 'RealReachability', '~> 1.2.2'
pod 'CocoaAsyncSocket', '~> 7.6.3'
#pod 'SJNavigationPopGesture', '~> 1.4.7'
pod 'IQKeyboardManagerSwift', '~> 6.0.2'
pod 'GDPerformanceView-Swift', '~> 2.0.2'

pod 'FSPagerView', '~> 0.8.1'
pod 'CHIPageControl/Jaloro', '~> 0.1.7'

#third platform
pod 'SDWebImage/Core'
pod 'DTCoreText', '~> 1.6.21'

end
