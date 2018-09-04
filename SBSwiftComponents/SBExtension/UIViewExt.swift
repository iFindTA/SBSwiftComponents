//
//  UIViewExt.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

public enum SBSceneState: Int {
    case idle
    case empty
    case loading
    case netBroken
}

public extension UIView {
    private struct pb_associatedKeys {
        static var state = "pb_scene_load_key"
        static var indicator = "pb_scene_indicator_key"
    }
    var state: SBSceneState {
        get{
            if let s = objc_getAssociatedObject(self, &pb_associatedKeys.state) as? SBSceneState {
                return s
            }
            return .idle
        }
        set{
            self.update(newValue)
            objc_setAssociatedObject(self, &pb_associatedKeys.state, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func loader() -> UIActivityIndicatorView {
        var acter: UIActivityIndicatorView!
        if let s = objc_getAssociatedObject(self, &pb_associatedKeys.indicator) as? UIActivityIndicatorView {
            acter = s
        } else {
            let a = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            a.hidesWhenStopped = true
            acter = a
            objc_setAssociatedObject(self, &pb_associatedKeys.indicator, a, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return acter
    }
    private func update(_ s: SBSceneState) {
        if s == .idle {
            self.loader().stopAnimating()
        } else if s == .loading {
            let loader = self.loader()
            if loader.superview == nil {
                self.addSubview(loader)
                loader.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                }
                self.layoutIfNeeded()
            }
            self.bringSubview(toFront: loader)
            loader.startAnimating()
        }
    }
}
