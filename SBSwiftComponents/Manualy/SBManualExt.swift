//
//  SBManualExt.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import Foundation


// MARK: - Base Profile手动扩展
extension BaseProfile {
    func app() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

// MARK: - Base Navigation手动扩展
extension UINavigationController {
    public func rooter() -> UIViewController? {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window?.rootViewController
    }
    public func defaultGoBack(_ excute: DelayedClosure? = nil) {
        let statcks = self.viewControllers
        if statcks.count <= 1 {
            guard let rooter = self.rooter() else {
                self.dismiss(animated: true, completion: excute)
                return
            }
            if self != rooter {
                self.dismiss(animated: true, completion: excute)
            }
        } else {
            // 初始化动画的持续时间，类型和子类型
            UIView.animate(withDuration: Macros.APP_ANIMATE_INTERVAL, animations: {[weak self]in
                self?.popViewController(animated: true)
            }) { (finish) in
                excute?()
            }
        }
    }
}
