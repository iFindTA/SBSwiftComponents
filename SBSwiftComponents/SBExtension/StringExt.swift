//
//  StringExt.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation

// MARK: - String Extension
public extension String {
    public func available() -> String {
        guard self.count > 0 else {
            return ""
        }
        return self
    }
    public func isMatchRegexPattern(_ p: String) -> Bool {
        guard self.isEmpty == false else {
            return false
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", p)
        return predicate.evaluate(with: self)
    }
}
public extension NSString {
    public func available() -> NSString {
        print(self.length)
        guard self.length > 0 else {
            return "" as NSString
        }
        return self
    }
}
