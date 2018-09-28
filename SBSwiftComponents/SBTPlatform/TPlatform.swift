//
//  TPlatform.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/25.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import SVProgressHUD
import AlamofireImage

fileprivate let THIRD_WX_APPID = "wxfa827e3c1a13590e"
fileprivate let THIRD_WX_APPSECRET = "1c07b1856958233045ea2892f7c4f444"
fileprivate let THIRD_QQ_APPID = "1107800935"
fileprivate let THIRD_QQ_APPSECRET = "3C41AyNMnJcV4Ap3"
fileprivate let THIRD_Ali_APPID = "2017092208862735"        //ali-pay

/// 所有支持的schemes
fileprivate let SCHEME_APP = "sxtn"                         //自身
fileprivate let SCHEME_WECHAT = "wxfa827e3c1a13590e"        //微信
fileprivate let SCHEME_QQSHARE = "QQ4207B367"               //QQ分享
fileprivate let SCHEME_QQOAUTH = "tencent1107800935"        //QQ授权

/// 所有支持的第三方平台
public enum TPlatform {
    case none
    case qq
    case ali
    case wxSession
    case wxTimeline
    case wxFavorite
}

/// 支付方式
public enum PPlatform: Int {
    case ali
    case wechat
    case applePay
}

/// 课程激活方式
@objc public enum ActiveType: Int {
    case active     //主动激活
    case relative   //学习关联
    case granted    //被分享
}

/// 支付状态
public enum PayStatus: Int {
    case cancel = 6001
    case network = 6002
    case uncertain = 6004
    case failed = 4000
    case dealing = 8000
    case success = 9000
    case repeatReq = 5000
    case unknown
    
    func desc() -> String {
        switch self {
        case .cancel:
            return "您已取消！"///取消支付
        case .network:
            return "网络连接出错！"
        case .uncertain:
            return "支付结果未知，请查询订单列表中订单的支付状态！"
        case .failed:
            return "失败！"///订单支付失败
        case .dealing:
            return "正在处理中，支付结果未知，请查询订单列表中订单的支付状态！"
        case .success:
            return "成功！"///订单支付成功
        case .repeatReq:
            return "重复支付请求！"
        default:
            return "支付结果未知！"
        }
    }
}

fileprivate let scene_height: CGFloat = 200
public typealias TShareCallback = (TPlatform)->Void

// MARK: - 第三方平台UI选择
class TPlatformProfile: BaseProfile {
    /// Callbacks
    public var callback: TShareCallback?
    
    private var color = RGBA(r: 153, g: 153, b: 153, a: 1)
    private var font = AppFont.pingFangBold(AppFont.SIZE_SUB_TITLE)
    private lazy var scene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    private lazy var btnScene: BaseScene = {
        let s = BaseScene()
        return s
    }()
    private lazy var cancelBtn: BaseButton = {
        let b = BaseButton(type: .custom)
        b.titleLabel?.font = AppFont.pingFangBold(AppFont.SIZE_SUB_TITLE+1)
        b.setTitleColor(color, for: .normal)
        b.setTitle("取消", for: .normal)
        b.layer.cornerRadius = AppSize.HEIGHT_SUBBAR*0.5
        b.layer.masksToBounds = true
        b.layer.borderWidth = AppSize.HEIGHT_LINE
        b.layer.borderColor = RGBA(r: 221, g: 221, b: 221, a: 1).cgColor
        b.addTarget(self, action: #selector(cancelShare), for: .touchUpInside)
        return b
    }()
    private lazy var qqBtn: BaseButton = {
        let b = BaseButton(type: .custom)
        let icon = UIImage(named: "icon_grant_qq")
        b.titleLabel?.font = font
        b.setTitleColor(color, for: .normal)
        b.setTitle("QQ好友", for: .normal)
        b.setImage(icon, for: .normal)
        b.addTarget(self, action: #selector(share2QQ), for: .touchUpInside)
        return b
    }()
    private lazy var wxBtn: BaseButton = {
        let b = BaseButton(type: .custom)
        let icon = UIImage(named: "icon_grant_wx")
        b.titleLabel?.font = font
        b.setTitleColor(color, for: .normal)
        b.setTitle("微信好友", for: .normal)
        b.setImage(icon, for: .normal)
        b.addTarget(self, action: #selector(share2WXSession), for: .touchUpInside)
        return b
    }()
    private lazy var dlBtn: BaseButton = {
        let b = BaseButton(type: .custom)
        let icon = UIImage(named: "icon_grant_dl")
        b.titleLabel?.font = font
        b.setTitleColor(color, for: .normal)
        b.setTitle("保存", for: .normal)
        b.setImage(icon, for: .normal)
        b.addTarget(self, action: #selector(save2Album), for: .touchUpInside)
        return b
    }()
    
    private var params: SBSceneRouteParameter?
    init(_ parameters: SBSceneRouteParameter?) {
        super.init(nibName: nil, bundle: nil)
        params = parameters
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        cancelShare()
    }
    @objc private func cancelShare() {
        SBSceneRouter.back()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ClearBgColor
        
        /// scene
        let bottom = AppSize.HEIGHT_INVALID_BOTTOM()
        view.addSubview(scene)
        scene.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(bottom+scene_height)
        }
        
        scene.addSubview(cancelBtn)
        cancelBtn.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(HorizontalOffsetMAX)
            make.right.equalToSuperview().offset(-HorizontalOffsetMAX)
            make.bottom.equalToSuperview().offset(-bottom-HorizontalOffset)
            make.height.equalTo(AppSize.HEIGHT_SUBBAR)
        }
        
        /// btn scene
        scene.addSubview(btnScene)
        btnScene.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(HorizontalOffsetMAX)
            make.right.equalToSuperview().offset(-HorizontalOffsetMAX)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-HorizontalOffset)
        }
        btnScene.addSubview(qqBtn)
        btnScene.addSubview(wxBtn)
        qqBtn.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(wxBtn.snp.left)
            make.width.equalTo(wxBtn.snp.width)
        }
        wxBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(qqBtn.snp.width)
        }
        let space = AppSize.WIDTH_DIS
        wxBtn.sb_fixImagePosition(.top, spacing: space)
        qqBtn.sb_fixImagePosition(.top, spacing: space)
    }
    @objc private func share2QQ() {
        share2(.qq)
    }
    @objc private func share2WXSession() {
        share2(.wxSession)
    }
    @objc private func share2WXTimeline() {
        share2(.wxTimeline)
    }
    @objc private func share2WXFavorite() {
        share2(.wxFavorite)
    }
    private func share2(_ platform: TPlatform) {
        let clousure: NoneClosure = {[weak self] in
            self?.callback?(platform)
        }
        SBSceneRouter.back(nil, excute: clousure)
    }
    @objc private func save2Album() {
        
    }
}

// MARK: - 第三方平台组件API调用
public class TPOpen: NSObject {
    
    /// Callbacks
    public var callback: ErrorClosure?
    
    public var qqAuth: TencentOAuth?
    public static let shared = TPOpen()
    private override init() {}
    
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
        case .wxSession, .wxFavorite, .wxTimeline:
            ret = WXApi.isWXAppInstalled()
        default:
            ret = false
        }
        return ret
    }
    /// 是否handle
    public func handle(_ uri: URL) -> Bool {
        guard let scheme = uri.scheme else {
            debugPrint("could not handle empty scheme:\(uri.absoluteString)")
            return false
        }
        /// universal-link/scheme-url
        if scheme.hasPrefix(SCHEME_APP) {
            TUniversalHandler.shared.handle(uri)
            return true
        }
        /// wx oauth/share
        if scheme.hasPrefix(SCHEME_WECHAT) {
            return WXApi.handleOpen(uri, delegate: TWXHandler.shared)
        }
        /// qq oauth
        if scheme.hasPrefix(SCHEME_QQOAUTH) {
            TencentOAuth.handleOpen(uri)
            return true
        }
        /// qq share
        if scheme.hasPrefix(SCHEME_QQSHARE) {
            return QQApiInterface.handleOpen(uri, delegate: TQQHandler.shared)
        }
        /// ali
        if let host = uri.host, host.hasSuffix("safepay") {
            TAliHandler.shared.handle(uri)
            return true
        }
        
        return true
    }
    /// 分享网页链接
    public func shareLink(_ platform: [TPlatform], title: String, desciption desc: String, icon uri: String, hybrid link: String, profile: UIViewController, completion:@escaping ErrorClosure) {
        /// weak refrerence
        callback = completion
        
        let qqInstalled = isInstalled(.qq)
        let wxInstalled = isInstalled(.wxSession)
        if qqInstalled && wxInstalled {
            var p = SBSceneRouteParameter()
            p["platforms"] = platform
            let plater = TPlatformProfile(p)
            let rooter = BaseNavigationProfile(rootViewController: plater)
            rooter.view.backgroundColor = ClearBgColor
            rooter.modalPresentationStyle = .overCurrentContext
            rooter.setNavigationBarHidden(true, animated: true)
            profile.present(rooter, animated: true, completion: nil)
            plater.callback = {[weak self](platform) in
                self?.shareLinkThrid(platform, title: title, desciption: desc, icon: uri, hybrid: link)
            }
            return
        }
        shareLinkSystem(title: title, desciption: desc, icon: uri, hybrid: link, profile: profile)
    }
    /// 选择分享平台
    private func previousChoosenPlatform() {
        
    }
    private func shareLinkSystem(title: String, desciption desc: String, icon uri: String, hybrid link: String, profile: UIViewController) {
        var image: UIImage = UIImage()
        if let i = UIImage(named: "AppIcon") {
            image = i
        }
        
        let items:[Any] = [title, desc, image, link]
        let shreProfile = UIActivityViewController(activityItems: items, applicationActivities: nil)
        shreProfile.excludedActivityTypes = [.mail, .print, .airDrop, .message, .postToVimeo, .postToFlickr, .postToTwitter, .assignToContact, .saveToCameraRoll, .addToReadingList, .copyToPasteboard, .postToTencentWeibo]
        shreProfile.completionWithItemsHandler = { [weak self](type, completed, returnItems, error) in
            var err: BaseError?
            if completed == false, let e = error {
                err = BaseError(e.localizedDescription)
            }
            self?.callback?(err)
        }
        profile.present(shreProfile, animated: true, completion: nil)
    }
    private func shareLinkThrid(_ platform: TPlatform, title: String, desciption desc: String, icon uri: String, hybrid link: String) {
        
        SVProgressHUD.show()
        Alamofire.request(uri).responseImage { [weak self](response) in
            SVProgressHUD.dismiss()
            guard let icon = response.result.value else {
                let e = BaseError("f分享图片数据错误！")
                self?.callback?(e)
                return
            }
            /// compress
            let compressed = icon.sb_compress(32768)
            //            guard let compressed = icon.sb_compress(32768) else {
            //                debugPrint("failed compress")
            //                let e = BaseError("failed compress")
            //                self?.callback?(e)
            //                return
            //            }
            /// share
            self?.realShareLink(platform, title: title, desciption: desc, icon: compressed, hybrid: link)
        }
    }
    private func realShareLink(_ platform: TPlatform, title: String, desciption desc: String, icon source: UIImage, hybrid link: String) {
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
            realShareImage(platform, icon: data)
            return
        }
        shareImageSystem(source, profile: profile)
    }
    private func shareImageSystem(_ icon: UIImage, profile: UIViewController) {
        let items:[Any] = [icon]
        let shreProfile = UIActivityViewController(activityItems: items, applicationActivities: nil)
        shreProfile.excludedActivityTypes = [.mail, .print, .airDrop, .message, .postToVimeo, .postToFlickr, .postToTwitter, .assignToContact, .saveToCameraRoll, .addToReadingList, .copyToPasteboard, .postToTencentWeibo]
        shreProfile.completionWithItemsHandler = { [weak self](type, completed, returnItems, error) in
            var err: BaseError?
            if completed == false, let e = error {
                err = BaseError(e.localizedDescription)
            }
            self?.callback?(err)
        }
        profile.present(shreProfile, animated: true, completion: nil)
    }
    private func realShareImage(_ platform: TPlatform, icon source: Data) {
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
    
    /// 支付
    public func pay(_ order: JSON?, payment way: PPlatform, completion:@escaping ErrorClosure) {
        /// weak refrerence
        callback = completion
        
        guard let json = order else {
            let err = BaseError("创建订单失败！")
            completion(err)
            return
        }
        
        switch way {
        case .ali:
            //let orderNum = json["orderNo"]
            let signature = json["sign"]
            debugPrint("ali order sign:\(signature.stringValue)")
            AlipaySDK.defaultService().payOrder(signature.stringValue, fromScheme: THIRD_Ali_APPID) { _ in /*called by web pay*/}
        case .wechat:
            let req = PayReq()
            req.partnerId = json["mch_id"].stringValue//商户ID
            req.prepayId = json["prepay_id"].stringValue
            req.package = "Sign=WXPay"
            req.nonceStr = json["nonce_str"].stringValue
            req.timeStamp = json["timeStamp"].uInt32Value
            req.sign = json["sign"].stringValue
            WXApi.send(req)
        default:
            debugPrint("unknown payment!")
        }
    }
    
    /// 三方登录
    public func oauth(_ platform: TPlatform, completion:@escaping ErrorClosure) {
        /// weak reference
        callback = completion
        
        switch platform {
        case .qq:
            debugPrint("qq oauth")
            let grants: [Any] = [kOPEN_PERMISSION_GET_INFO]
            qqAuth?.authorize(grants)
        case .wxSession, .wxTimeline, .wxFavorite:
            let req = SendAuthReq()
            req.scope = "snsapi+userinfo"
            req.state = "auth2_wx"
            WXApi.send(req)
        default:
            debugPrint("unkown platform to oauth!")
        }
    }
}

// MARK: - QQ SDK回调
class TQQHandler: NSObject, QQApiInterfaceDelegate, TencentSessionDelegate {
    /// TencentSessionDelegate
    func tencentDidLogin() {
        debugPrint("tencentDidLogin")
        guard let auth = TPOpen.shared.qqAuth, let token = auth.accessToken, let openid = auth.openId else {
            let e = BaseError("QQ登录异常！")
            TPOpen.shared.callback?(e)
            return
        }
        var p = [String: Any]()
        p["openId"] = openid
        p["accessToken"] = token
        var e = BaseError("")
        e.code = 0
        e.ext = p
        TPOpen.shared.callback?(e)
    }
    func tencentDidNotLogin(_ cancelled: Bool) {
        let e = BaseError( cancelled ? "取消登录！" : "登录失败！")
        TPOpen.shared.callback?(e)
    }
    func tencentDidNotNetWork() {
        let e = BaseError("网络不畅！")
        TPOpen.shared.callback?(e)
    }
    
    public static let shared = TQQHandler()
    private override init() {}
    public func onReq(_ req: QQBaseReq!) { }
    public func isOnlineResponse(_ response: [AnyHashable : Any]!) {  }
    
    public func onResp(_ resp: QQBaseResp!) {
        debugPrint("qq shre response")
        if let ret = resp as? SendMessageToQQResp {
            var desc: String! = "成功！"
            var code: Int = 0
            if ret.result != "0" {
                desc = "失败"
                code = -1
            }
            var e = BaseError(desc)
            e.code = code
            TPOpen.shared.callback?(e)
        }
    }
}

// MARK: - 微信SDK回调
class TWXHandler: NSObject, WXApiDelegate {
    public static let shared = TWXHandler()
    private override init() {}
    /// callback
    public func onResp(_ resp: BaseResp!) {
        debugPrint("wx response")
        
        /// whether share
        if let ret = resp as? SendAuthResp {
            /// 授权
            var p = [String: Any]()
            p["code"] = ret.code
            var e = convertResp2(ret)
            e.ext = p
            TPOpen.shared.callback?(e)
        } else if let ret = resp as? PayResp {
            /// 支付
            let e = convertResp2(ret)
            TPOpen.shared.callback?(e)
        } else if let ret = resp as? SendMessageToWXResp {
            ///分享
            let e = convertResp2(ret)
            TPOpen.shared.callback?(e)
        }
    }
    private func convertResp2(_ resp: BaseResp) -> BaseError {
        var status: PayStatus = .unknown
        switch resp.errCode {
        case 0:
            status = .success
        case -1:
            status = .failed
        case -2:
            status = .cancel
        default:
            status = .unknown
        }
        //callback
        var e = BaseError(status.desc())
        e.code = Int(resp.errCode)
        return e
    }
}

// MARK: - 阿里支付
class TAliHandler: NSObject {
    public static let shared = TAliHandler()
    private override init() {}
    
    /// handle
    public func handle(_ url: URL) {
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (result) in
            if let ret: [String: Any] = result as? [String : Any] {
                let json = JSON(ret)
                let code = json["resultStatus"].intValue
                var status: PayStatus = .unknown
                if let stat = PayStatus(rawValue: code) {
                    status = stat
                }
                //                var orderNo: String?
                //                if status == .success {
                //                    let result = json["result"].stringValue
                //                    let retJson = JSON.init(parseJSON: result)
                //                    let appPay = retJson["alipay_trade_app_pay_response"]
                //                    let res = appPay["trade_no"]
                //                    orderNo = res.stringValue
                //                }
                
                //callback
                var e = BaseError(status.desc())
                if status == .success {
                    e.code = 0
                }
                TPOpen.shared.callback?(e)
            }
        }
    }
}

@objc protocol ActiveProtocol {
    @objc optional func active(_ map: [String: Any], with type: ActiveType)
}
// MARK: - 扫码/网页universal-link 打开app
class TUniversalHandler: NSObject {
    public static let shared = TUniversalHandler()
    private override init() {}
    
    public var delegate: ActiveProtocol?
    
    /// handle shceme-url
    public func handle(_ url: URL) {
        handleScan(url, completion: nil)
    }
    /// 扫码处理
    public func handleScan(_ link: URL, completion: ErrorClosure?=nil) {
        /// weak ref
        TPOpen.shared.callback = completion
        
        /// check scheme
        guard let scheme = link.scheme else {
            let e = BaseError("未知的应用scheme！")
            completion?(e)
            return
        }
        var uri: String = link.absoluteString
        let charactor = String(format: "url=%@", SCHEME_APP)
        if scheme.hasPrefix("http"), uri.contains(charactor) {
            let tmp_url = NSString(string: uri)
            let range = tmp_url.range(of: "url=")
            let len = tmp_url.length
            let start = range.location+range.length
            uri = tmp_url.substring(with: NSMakeRange(start, len-start))
        }
        var map = [String:Any]()
        guard let items = URLComponents(string: uri)?.queryItems else {
            debugPrint("empty items!")
            let err = BaseError("缺少query参数！")
            completion?(err)
            return
        }
        for q in items {
            map[q.name] = q.value
        }
        debugPrint("parser:\(map)")
        /// 激活类型
        var type: ActiveType = .active
        if uri.contains("curItemId") {
            type = .relative
        } else if uri.contains("share_course") {
            type = .granted
        }
        //active(map, with: type)
        delegate?.active?(map, with: type)
    }
}
