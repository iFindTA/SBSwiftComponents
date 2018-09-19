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
    
    public func route() -> String {
        switch self {
        case .empty:
            return "TestEmptyProfile"
        default:
            return "SB404"
        }
    }
}
