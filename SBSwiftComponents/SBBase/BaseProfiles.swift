//
//  BaseProfiles.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import Foundation

//MARK: - Base Profile
class BaseProfile: UIViewController {
    //MARK: - Variables
    lazy var navigationBar: BaseNavigationBar = {
        let n = BaseNavigationBar()
        let tintColor = AppColor.COLOR_NAVIGATOR_TINT
        let barTintColor = UIColor.white //影响背景
        let font = AppFont.pingFangSC(AppFont.SIZE_LARGE_TITLE)
        n.barStyle = .black
        let bgImg = UIImage.pb_imageWithColor(barTintColor);
        n.setBackgroundImage(bgImg, for: .default)
        n.shadowImage = UIImage()
        n.barTintColor = barTintColor
        n.tintColor = tintColor
        n.isTranslucent = false
        n.titleTextAttributes = {[
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor:tintColor
            ]}()
        return n
    }()
}
