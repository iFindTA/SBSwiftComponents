//
//  TPlatform.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/25.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation

fileprivate let THIRD_WX_APPID = "wxfa827e3c1a13590e"
fileprivate let THIRD_WX_APPSECRET = "1c07b1856958233045ea2892f7c4f444"
fileprivate let THIRD_QQ_APPID = "1107032734"
fileprivate let THIRD_QQ_APPSECRET = "jpxcrr67Et52dkVS"

public enum TPlatform {
    case qq
    case wxSession
    case wxTimeline
    case wxFavorite
}

/// 第三方组件
public class TPOpen: NSObject {
    
}
