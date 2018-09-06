//
//  SBHTTPState.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/6.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation
import RealReachability

fileprivate let APP_PING_HOST = "www.baidu.com"
fileprivate let APP_CHECK_HOST = "www.qq.com"

public class SBHTTPState {
    static let shared = SBHTTPState()
    private init() {
//        manager = NetworkReachabilityManager(host: Macros.APP_PING_HOST)
//        manager?.startListening()
        RealReachability.sharedInstance().hostForPing = APP_PING_HOST
        RealReachability.sharedInstance().hostForCheck = APP_CHECK_HOST
        RealReachability.sharedInstance().autoCheckInterval = 0.3
        RealReachability.sharedInstance().reachability { (status) in
            debugPrint("network status:\(status.rawValue)")
        }
        //TODO:此处可以发送消息给RN组件
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: NSNotification.Name.realReachabilityChanged, object: nil)
        RealReachability.sharedInstance().startNotifier()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.realReachabilityChanged, object: nil)
    }
    /// network status changed
    @objc private func networkStatusChanged() {
        let status = RealReachability.sharedInstance().currentReachabilityStatus()
        let reachable = (status != .RealStatusNotReachable)
        debugPrint("网络状态变化:\(reachable)")
    }
    
    public func isReachable() -> Bool {
        //        return (manager?.isReachable)!
        let status = RealReachability.sharedInstance().currentReachabilityStatus()
        return status != .RealStatusNotReachable
    }
    public func isViaWifi() -> Bool {
        //        return (manager?.isReachableOnEthernetOrWiFi)!
        let status = RealReachability.sharedInstance().currentReachabilityStatus()
        return status == .RealStatusViaWiFi
    }
}
