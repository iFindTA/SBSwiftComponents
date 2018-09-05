//
//  Kits.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Toaster
import Foundation

fileprivate struct DateFmt {
    public let fmt: DateFormatter!
    static let shared = DateFmt()
    private init() {
        debugPrint("once for fmt!")
        fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
}

public struct Kits {
    
    /// snadbox path
    private static func sandBoxPath() -> String {
        return NSHomeDirectory()
    }
    public static func locatePath(_ type: SBUserPath, owner: String?=nil) -> String {
        var path: String = sandBoxPath() + "/Documents/"
        switch type {
        case .file:
            path = path + "files"
        case .audio:
            path = path + "audios"
        case .image:
            path = path + "images"
        case .video:
            path = path + "videos"
        case .lyrics:
            path = path + "lyrics"
        case .record:
            path = path + "records"
        case .common:
            path = path + "commons"
        default:
            debugPrint("uncatch user sandbox type\(type.rawValue)")
        }
        if let o = owner, o.count > 0, type == .record {
            path = path + "/" + o
        }
        /// create dir if not exists
        let f = FileManager.default
        if f.fileExists(atPath: path) == false {
            do {
                let uri = URL(fileURLWithPath: path)
                try f.createDirectory(at: uri, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint("failed to create path:\(path)")
            }
        }
        return path
    }
    
    /// Toaster
    public static func makeToast(_ info: String?) {
        let offset = ToastView.appearance().bottomOffsetPortrait
        if offset < AppSize.HEIGHT_SCREEN*0.5 {
            ToastView.appearance().bottomOffsetPortrait = AppSize.HEIGHT_SCREEN*0.5
        }
        Toast(text: info).show()
    }
    
    
    /// check inputs
    public static func checkAccount(_ input: String?) -> (Bool, String?) {
        guard let m = input, m.count > 0 else{
            makeToast("请输入手机号码！")
            return (false, nil)
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", Macros.REGULAR_MOBILE)
        guard predicate.evaluate(with: m) else {
            makeToast("请输入正确的手机号码！")
            return (false, nil)
        }
        return (true, m)
    }
    public static func checkPasswd(_ input: String?) -> (Bool, String?) {
        guard let p = input else {
            makeToast("请输入密码！")
            return (false, nil)
        }
        if p.count < Macros.LENGTH_PWD_MIN {
            makeToast("请输入\(Macros.LENGTH_PWD_MIN)~\(Macros.LENGTH_PWD_MAX)位密码！")
            return (false, nil)
        }
        return (true, p)
    }
    public static func checkVerifyCode(_ input: String?) -> (Bool, String?) {
        guard let p = input else {
            makeToast("请输入验证码！")
            return (false, nil)
        }
        if p.count < Macros.LENGTH_CODE_MIN {
            makeToast("请输入\(Macros.LENGTH_CODE_MIN)~\(Macros.LENGTH_CODE_MAX)位数字验证码！")
            return (false, nil)
        }
        return (true, p)
    }
}
