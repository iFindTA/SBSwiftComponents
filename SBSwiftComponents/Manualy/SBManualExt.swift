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
