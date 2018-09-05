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
import RealReachability

// MARK: - Variables
public typealias SBResponse = (_ data: JSON?, _ error: BaseError?, _ page: JSON?) -> Void

// MARK: - 网络Router
struct SBHTTPRouter {
    /// variables
    private var manager: NetworkReachabilityManager?
    
    static let shared = SBHTTPRouter()
    private init() {
        
    }
}
