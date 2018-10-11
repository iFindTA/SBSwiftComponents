//
//  TestPaths.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/19.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation

public enum TestPaths: SBScenePathable {
    case test
    case empty
    case share
    case snapkit
    
    public func route() -> String {
        switch self {
        case .empty:
            return "TestEmptyProfile"
        case .share:
            return "TShare"
        case .snapkit:
            return "TestSnapkitProfile"
        default:
            return "SB404"
        }
    }
}
