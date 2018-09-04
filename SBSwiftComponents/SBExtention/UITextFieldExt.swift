//
//  UIKitExts.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import Foundation

extension UITextField {
    private struct pb_associatedKeys {
        static var acceptMaxLength = "pb_maxLength"
    }
    var maxLength: Int {
        set {
            objc_setAssociatedObject(self, &pb_associatedKeys.acceptMaxLength, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &pb_associatedKeys.acceptMaxLength) as? Int {
                return rs
            }
            
            return 0
        }
    }
}
