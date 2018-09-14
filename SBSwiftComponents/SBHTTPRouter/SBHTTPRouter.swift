//
//  SBHTTPRouter.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import SVProgressHUD

// MARK: - Variables
fileprivate let APP_TIMEOUT_INTERVAL  =   30.0
fileprivate let APP_PING_HOST = "www.baidu.com"
fileprivate let APP_CHECK_HOST = "www.qq.com"
public typealias SBResponse = (_ data: JSON?, _ error: BaseError?, _ page: JSON?) -> Void

// MARK: - Extension for Request
fileprivate extension DataRequest {
    private struct sb_associatedKeys {
        static var identifier_key = "identifier_key"
    }
    fileprivate var identifier: String {
        get {
            guard let i = objc_getAssociatedObject(self, &sb_associatedKeys.identifier_key) as? String else {
                return ""
            }
            return i
        }
        set {
            objc_setAssociatedObject(self, &sb_associatedKeys.identifier_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - 网络Router
public class SBHTTPRouter {
    /// variables
    //private var manager: NetworkReachabilityManager?
    
    public static let shared = SBHTTPRouter()
    private init() {
    }
    public func challengeNetworkPermission() {
        let url = URL(string: "https://baidu.com")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: APP_TIMEOUT_INTERVAL)
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    /// inner action
    private func responseFilter(_ res: DataResponse<Any>) -> DataResponse<Any>? {
        let code = res.response?.statusCode
        guard code != SBHTTPRespCode.unAuthorization.rawValue, code != SBHTTPRespCode.forbidden.rawValue else {
            return nil
        }
        return res
    }
    /// 返回401/403错误
    private func didCameForbiddenQuery() {
        //TODO:可以发送通知
    }
    
    /// network fetch event
    public func fetch(_ request: URLRequestConvertible, hud: Bool=true, hudString: String="请稍后...", completion:@escaping SBResponse) -> Void {
        if hud {
            SVProgressHUD.show(withStatus: hudString)
        }
        let session = Alamofire.SessionManager.default
        let req = session.request(request).responseJSON { [weak self](response) in
            if hud {
                SVProgressHUD.dismiss()
            }
            self?.handle(response, completion: completion)
        }
        req.identifier = "task"
    }
    private func handle(_ response: DataResponse<Any>, completion:@escaping SBResponse) -> Void {
        /// step1 filter response for authorization
        guard let newRes = responseFilter(response) else {
            var e = BaseError("授权已过期！")
            e.code = SBHTTPRespCode.forbidden.rawValue
            completion(nil, e, nil)
            didCameForbiddenQuery()
            return
        }
        
        /// step2 check error
        if let err = newRes.error {
            let e = BaseError(err.localizedDescription)
            completion(nil, e, nil)
            return
        }
        
        /// step3 check inner status
        guard newRes.result.isSuccess, let value = newRes.result.value, let json = JSON.init(rawValue: value) else {
            let e = BaseError("Oops，发生了系统错误！")
            completion(nil, e, nil)
            return
        }
        
        /// then, check status for this do-action
        var e: BaseError?
        if json["status"].intValue != 0 {
            e = BaseError(json["error"].stringValue)
        }
        /// finally, callback
        let page = json["page"]
        completion(json["data"], e, page)
    }
    public func cancelAll() {
        let session = Alamofire.SessionManager.default
        session.session.getAllTasks { (tasks) in
            tasks.forEach({ (t) in
                t.cancel()
            })
        }
    }
}
