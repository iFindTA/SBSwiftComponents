//
//  BaseScenes.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import Foundation

//MARK: - 全局布局定义变量
let HorizontalOffset = AppSize.WIDTH_MARGIN
let HorizontalOffsetMAX = AppSize.WIDTH_BOUNDARY
let SeperatorBgColor = RGBA(r: 244, g: 243, b: 245, a: 1)
let ClearBgColor = UIColor(white: 0, alpha: 0.3)

// MARK: - UIButton类
class BaseButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(type buttonType: UIButtonType) {
        super.init(frame: .zero)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let preEventStamp = self.pb_acceptEventTime
        let duration = self.pb_acceptEventInterval
        let curEventStamp = Date().timeIntervalSince1970
        if abs(preEventStamp - curEventStamp) > duration {
            super.touchesBegan(touches, with: event)
        }
        self.pb_acceptEventTime = curEventStamp
    }
    
    public var extendTag: Int = 0//扩展的属性 方便操作
}

// MARK: - UILbel类
class BaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
    }
}

// MARK: - UIImageView类
class BaseImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.contentMode = .scaleToFill
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - UIScrollView类
class BaseScrollView: UIScrollView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}
extension BaseScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesCancelled(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
}

// MARK: - UITableView 类
class BaseTableView: UITableView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension BaseTableView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesCancelled(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
}

// MARK: - UIView
class BaseScene: UIView {
    
    public var sectionTag: Int = 0
    
    deinit {
        print("scene 析构: class: \(type(of: self))")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: 用户相关
    func app() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

// MARK: - UINavigationBar
class BaseNavigationBar: UINavigationBar {
    var offset:CGFloat {
        guard UIDevice.current.isX() else {
            return 0
        }
        return 30
    }
    //*
    override func layoutSubviews() {
        super.layoutSubviews()
        //status bar height
        let statusBarHeight = AppSize.HEIGHT_STATUSBAR()
        let navigationBarHeight = AppSize.HEIGHT_NAVIGATIONBAR
        
        let allHeight = statusBarHeight+navigationBarHeight
        self.frame = CGRect(x: 0, y: 0, width: AppSize.WIDTH_SCREEN, height: allHeight)
        for v in self.subviews {
            let clsString = NSStringFromClass(type(of: v))
            if clsString.contains("Background") {
                v.frame = self.bounds
            } else if clsString.contains("ContentView") {
                var frame = v.frame;
                //frame.origin.x -= self.offset * 0.5;
                frame.origin.x = 0
                frame.origin.y = statusBarHeight;
                frame.size.height = allHeight - statusBarHeight;
                //frame.size.width += self.offset;
                frame.size.width = AppSize.WIDTH_SCREEN
                v.frame = frame;
            }
        }
        
    }
}
