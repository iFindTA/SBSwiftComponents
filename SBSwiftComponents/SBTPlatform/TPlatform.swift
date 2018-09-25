//
//  TPlatform.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/25.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Alamofire
import Foundation
import SVProgressHUD
import AlamofireImage

fileprivate let THIRD_WX_APPID = "wxfa827e3c1a13590e"
fileprivate let THIRD_WX_APPSECRET = "1c07b1856958233045ea2892f7c4f444"
fileprivate let THIRD_QQ_APPID = "1107032734"
fileprivate let THIRD_QQ_APPSECRET = "jpxcrr67Et52dkVS"

public enum TPlatform {
    case none
    case qq
    case wxSession
    case wxTimeline
    case wxFavorite
}

/// 第三方组件
public class TPOpen: NSObject {
    
    /// Callbacks
    public var callback: ErrorClosure?
    
    private var qqAuth: TencentOAuth?
    public static let shared = TPOpen()
    private override init() {
        
    }
    
    /// 注册IDs
    public func install() {
        WXApi.registerApp(THIRD_WX_APPID)
        qqAuth = TencentOAuth(appId: THIRD_QQ_APPID, andDelegate: TQQHandler.shared)
    }
    public func isInstalled(_ type: TPlatform) -> Bool {
        var ret: Bool = false
        switch type {
        case .qq:
            ret = QQApiInterface.isQQInstalled()
        case .wxSession,.wxFavorite, .wxTimeline:
            ret = WXApi.isWXAppInstalled()
        default:
            ret = false
        }
        return ret
    }
    /// 是否handle
    public func handle(_ uri: URL) -> Bool {
        /// wx
        guard WXApi.handleOpen(uri, delegate: TWXHandler.shared) else {
            return false
        }
        /// qq
        guard QQApiInterface.handleOpen(uri, delegate: TQQHandler.shared) else {
            return false
        }
        guard TencentOAuth.canHandleOpen(uri) else {
            TencentOAuth.handleOpen(uri)
            return false
        }
        
        return true
    }
    /// 分享网页链接
    public func shareLink(_ platform: [TPlatform], title: String, desciption desc: String, icon uri: String, hybrid link: String, profile: UIViewController, completion:@escaping ErrorClosure) {
        let qqInstalled = isInstalled(.qq)
        let wxInstalled = isInstalled(.wxSession)
        if qqInstalled && wxInstalled {
            var p = SBSceneRouteParameter()
            p["platforms"] = platform
            let plater = TShare(p)
            let rooter = BaseNavigationProfile(rootViewController: plater)
            rooter.view.backgroundColor = ClearBgColor
            rooter.modalPresentationStyle = .overCurrentContext
            rooter.setNavigationBarHidden(true, animated: true)
            profile.present(rooter, animated: true, completion: nil)
            plater.callback = {[weak self](platform) in
                self?.shareLinkThrid(platform, title: title, desciption: desc, icon: uri, hybrid: link, completion: completion)
            }
            return
        }
        shareLinkSystem(title: title, desciption: desc, icon: uri, hybrid: link, profile: profile, completion: completion)
    }
    /// 选择分享平台
    private func previousChoosenPlatform() {
        
    }
    private func shareLinkSystem(title: String, desciption desc: String, icon uri: String, hybrid link: String, profile: UIViewController,  completion:@escaping ErrorClosure) {
        var image: UIImage = UIImage()
        if let i = UIImage(named: "AppIcon") {
            image = i
        }
        
        let items:[Any] = [title, desc, image, link]
        let shreProfile = UIActivityViewController(activityItems: items, applicationActivities: nil)
        shreProfile.excludedActivityTypes = [.mail, .print, .airDrop, .message, .postToVimeo, .postToFlickr, .postToTwitter, .assignToContact, .saveToCameraRoll, .addToReadingList, .copyToPasteboard, .postToTencentWeibo]
        shreProfile.completionWithItemsHandler = {(type, completed, returnItems, error) in
            var err: BaseError?
            if completed == false, let e = error {
                err = BaseError(e.localizedDescription)
            }
            completion(err)
        }
        profile.present(shreProfile, animated: true, completion: nil)
    }
    private func shareLinkThrid(_ platform: TPlatform, title: String, desciption desc: String, icon uri: String, hybrid link: String, completion:@escaping ErrorClosure) {
        
        SVProgressHUD.show()
        Alamofire.request(uri).responseImage { [weak self](response) in
            guard let icon = response.result.value else {
                SVProgressHUD.showError(withStatus: "分享图片数据错误！")
                return
            }
            SVProgressHUD.dismiss()
            /// compress
            guard let compressed = self?.compress(icon, to: 32768) else {
                debugPrint("failed compress")
                return
            }
            /// share
            self?.realShareLink(platform, title: title, desciption: desc, icon: compressed, hybrid: link, completion: completion)
        }
    }
    private func realShareLink(_ platform: TPlatform, title: String, desciption desc: String, icon source: UIImage, hybrid link: String, completion:@escaping ErrorClosure) {
        if platform == .wxSession || platform == .wxTimeline || platform == .wxFavorite {
            let msg = WXMediaMessage()
            msg.title = title
            msg.description = desc
            msg.setThumbImage(source)
            let webp = WXWebpageObject()
            webp.webpageUrl = link
            msg.mediaObject = webp
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = (platform == .wxSession ? 0 : (platform == .wxTimeline ? 1 : 2))//WXSceneSession
            req.message = msg
            WXApi.send(req)
        } else if platform == .qq {
            let data = UIImageJPEGRepresentation(source, 1)
            let obj = QQApiNewsObject.object(with: URL(string: link)!, title: title, description: desc, previewImageData: data)
            let req = SendMessageToQQReq(content: obj as! QQApiObject)
            let code = QQApiInterface.send(req)
            debugPrint("code:\(code.rawValue)")
        }
    }
    
    private func compress(_ image: UIImage, to size: Int) -> UIImage? {
        // Compress by quality
        var compression: CGFloat = 1
        var data: Data? = UIImageJPEGRepresentation(image, compression)
        if (data?.count ?? 0) < size {
            return image
        }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(image, compression)
            if Double((data?.count ?? 0)) < Double(size) * 0.9 {
                min = compression
            } else if (data?.count ?? 0) > size {
                max = compression
            } else {
                break
            }
        }
        
        guard let aData = data else {
            debugPrint("mpty")
            return nil
        }
        var resultImage: UIImage! = UIImage(data: aData)
        if  aData.count < size {
            return UIImage(data: aData)
        }
        
        var tmpData = aData
        // Compress by size
        var lastDataLength: Int = 0
        while tmpData.count > size && tmpData.count != lastDataLength {
            lastDataLength = tmpData.count
            let ratio = Float(size) / Float(tmpData.count)
            let size = CGSize(width: CGFloat(Int(resultImage.size.width * CGFloat(sqrtf(ratio)))), height: CGFloat(Int(resultImage.size.height * CGFloat(sqrtf(ratio))))) // Use NSUInteger to prevent white blank
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            tmpData = UIImageJPEGRepresentation(resultImage, compression)!
        }
        
        return resultImage
    }
    
    
    /// 分享纯图片
    public func shareImage(_ platform: TPlatform, icon source: UIImage, profile: UIViewController, completion:@escaping ErrorClosure) {
        
        let qqInstalled = isInstalled(.qq)
        let wxInstalled = isInstalled(.wxSession)
        if qqInstalled && wxInstalled {
            guard let data = UIImageJPEGRepresentation(source, 1.0) else {
                let e = BaseError("failed convert image to data binary!")
                completion(e)
                return
            }
            realShareImage(platform, icon: data, completion: completion)
            return
        }
        shareImageSystem(source, profile: profile, completion: completion)
    }
    private func shareImageSystem(_ icon: UIImage, profile: UIViewController, completion:@escaping ErrorClosure) {
        let items:[Any] = [icon]
        let shreProfile = UIActivityViewController(activityItems: items, applicationActivities: nil)
        shreProfile.excludedActivityTypes = [.mail, .print, .airDrop, .message, .postToVimeo, .postToFlickr, .postToTwitter, .assignToContact, .saveToCameraRoll, .addToReadingList, .copyToPasteboard, .postToTencentWeibo]
        shreProfile.completionWithItemsHandler = {(type, completed, returnItems, error) in
            var err: BaseError?
            if completed == false, let e = error {
                err = BaseError(e.localizedDescription)
            }
            completion(err)
        }
        profile.present(shreProfile, animated: true, completion: nil)
    }
    private func realShareImage(_ platform: TPlatform, icon source: Data, completion:@escaping ErrorClosure) {
        if platform == .wxSession || platform == .wxTimeline || platform == .wxFavorite {
            let msg = WXMediaMessage()
            let obj = WXImageObject()
            obj.imageData = source
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = (platform == .wxSession ? 0 : (platform == .wxTimeline ? 1 : 2))//WXSceneSession
            req.message = msg
            WXApi.send(req)
        } else if platform == .qq {
            let obj = QQApiImageObject(data: source, previewImageData: source, title: "", description: "")
            let req = SendMessageToQQReq(content: obj)
            let code = QQApiInterface.send(req)
            debugPrint("code:\(code.rawValue)")
        }
    }
}

// MARK: - 微信SDK回调
class TWXHandler: NSObject, WXApiDelegate {
    public static let shared = TWXHandler()
    private override init() {
        
    }
    /// callback
    public func onResp(_ resp: BaseResp!) {
        
    }
}

// MARK: - QQ SDK回调
class TQQHandler: NSObject, QQApiInterfaceDelegate, TencentSessionDelegate {
    /// TencentSessionDelegate
    func tencentDidLogin() {
        debugPrint("tencentDidLogin")
    }
    func tencentDidNotLogin(_ cancelled: Bool) {
        debugPrint("tencentDidNotLogin")
    }
    func tencentDidNotNetWork() {
        debugPrint("tencentDidNotNetWork")
    }
    
    public static let shared = TQQHandler()
    private override init() {
        
    }
    public func onReq(_ req: QQBaseReq!) {
        
    }
    
    public func onResp(_ resp: QQBaseResp!) {
        
    }
    
    public func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
    
    
}
