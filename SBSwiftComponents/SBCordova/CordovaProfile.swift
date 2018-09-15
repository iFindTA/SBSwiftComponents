//
//  CordovaProfile.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/6.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import WebKit
import Cordova
import Foundation

public class CordovaProfile: CDVViewController {
    /// - Variables
    public lazy var navigationBar: BaseNavigationBar = {
        let n = BaseNavigationBar()
        let tintColor = AppColor.COLOR_NAVIGATOR_TINT
        let barTintColor = UIColor.white //影响背景
        let font = AppFont.pingFangSC(AppFont.SIZE_LARGE_TITLE)
        n.barStyle = .black
        let bgImg = generateBgImage(barTintColor);
        n.setBackgroundImage(bgImg, for: .default)
        n.shadowImage = UIImage()
        n.barTintColor = barTintColor
        n.tintColor = tintColor
        n.isTranslucent = false
        n.titleTextAttributes = {[
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor:tintColor
            ]}()
        return n
    }()
    
    /// - private methods
    private func generateBgImage(_ color: UIColor) -> UIImage {
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    var params: SBSceneRouteParameter?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ parameters: SBSceneRouteParameter?) {
        self.params = parameters
        super.init(nibName: nil, bundle: nil)
        
        if let start = self.params![Macros.CORDOVA_KEY_STARTPAGE] as? String {
            let wwwPath = self.wwwFolderPath()
            self.startPage = wwwPath+"/"+start
            debugPrint("cordova start page:\(self.startPage)")
        } else {
            fatalError("cooud not start with empty uri!")
        }
    }
    
    private func wwwFolderPath() -> String {
        let documentsPath = Kits.locatePath(.root)
        return documentsPath+"/"+"www"
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc dynamic var appUrl: NSURL {
        get {
            return NSURL(string: self.startPage)!
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.commandDelegate.evalJs("viewWillAppear&&viewWillAppear()")
        //FIXME: 此处逻辑可由网页JS实现
//        if !SBHTTPRouter.shared.isReachable() {
//            let err = BaseError.init(Macros.EMPTY_NETWORK)
//            Kits.handleError(err)
//        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
}

// MARK: - router protocol
extension CordovaProfile: SBSceneRouteable {
    public static func __init(_ params: SBSceneRouteParameter?) -> UIViewController {
        return CordovaProfile(params)
    }
}
