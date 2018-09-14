//
//  BaseError.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation

public struct BaseError: LocalizedError {
    // MARK: - Variables
    var desc: String = ""
    public var code: Int = 0
    var localizedDescription: String {
        return desc
    }
    var errDescription: String {
        return desc
    }
    public init(_ desc: String) {
        self.desc = desc
    }
}
