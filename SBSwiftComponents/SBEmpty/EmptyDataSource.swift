//
//  EmptyDataSource.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/6.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

fileprivate let EmptyImageName = "emptyDataSource"
fileprivate let EmptyColor = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
public typealias emptyShouldDisplay = () -> Bool
public typealias emptyDisplayDescription = ()->String
public typealias emptyPlaceholderTrigger = () -> Void

// MARK: - 方式1
public class EmptyDataSource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    /*singletone method
     static let shared = VMEmpty()
     private override init() {
     super.init()
     }*/
    
    public var shouldDisplay: emptyShouldDisplay?
    public var displayDescription: emptyDisplayDescription?
    public var didTrigger: emptyPlaceholderTrigger?
    
    // MARK: empty delegate & dataSource
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        guard shouldDisplay != nil else {
            return true
        }
        return shouldDisplay!()
    }
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        guard let icon = EmptyDataSource.bundledImage(named: EmptyImageName) else {
            return UIImage()
        }
        return icon
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let font = UIFont(name: AppFont.PF_BOLD, size: AppFont.SIZE_TITLE)
        let fontColor = EmptyColor
        var attributes = [NSAttributedStringKey: Any]()
        attributes[NSAttributedStringKey.font] = font
        attributes[NSAttributedStringKey.foregroundColor] = fontColor
        return NSAttributedString(string: Macros.EMPTY_TITLE, attributes: attributes)
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let font = UIFont(name: AppFont.PF_BOLD, size: AppFont.SIZE_SUB_TITLE)
        let fontColor = EmptyColor
        var attributes = [NSAttributedStringKey: Any]()
        attributes[NSAttributedStringKey.font] = font
        attributes[NSAttributedStringKey.foregroundColor] = fontColor
        guard SBHTTPState.shared.isReachable() else {
            return NSAttributedString(string: Macros.EMPTY_NETWORK, attributes: attributes)
        }
        var display = Macros.EMPTY_DATA
        if let displayCallback = displayDescription {
            display = displayCallback()
        }
        return NSAttributedString(string: display, attributes: attributes)
    }
    
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -20
    }
    
    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        guard didTrigger != nil else {
            return
        }
        didTrigger!()
    }
    
    fileprivate class func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return UIImage(named: named, in: Bundle(for: EmptyDataSource.classForCoder()), compatibleWith: nil)
        }
        return image
    }
}

// MARK: - 方式2
public extension BaseTableView {
    public func empty(_ title: String, with description: String, height: CGFloat=300) {
        let footer = assemble(title, with: description, height: height)
        tableFooterView = footer
    }
    private func assemble(_ title: String, with description: String, height: CGFloat=300) -> UIView {
        let b = CGRect(x: 0, y: 0, width: AppSize.WIDTH_SCREEN, height: height)
        let scene = BaseScene(frame: b)
        let icon = EmptyDataSource.bundledImage(named: EmptyImageName)
        let whetherShowAction = title.count > 0///是否显示button
        /// desc
        var font = AppFont.pingFangSC(AppFont.SIZE_SUB_TITLE)
        var color = AppColor.COLOR_CCCCCC
        let lab = BaseLabel(frame: .zero)
        lab.font = font
        lab.textColor = color
        lab.textAlignment = .center
        lab.text = description
        scene.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.left.right.equalToSuperview()
        }
        /// icon
        let iconView = BaseImageView(frame: .zero)
        iconView.image = icon
        scene.addSubview(iconView)
        iconView.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.bottom.equalTo(lab.snp.top).offset(-HorizontalOffset)
        }
        /// title event
        if whetherShowAction {
            let bh = AppSize.HEIGHT_SUBBAR
            let bw = bh*3
            color = AppColor.COLOR_TITLE_LIGHTGRAY
            font = AppFont.pingFangSC(AppFont.SIZE_SUB_TITLE+1)
            let bgColor = RGBA(r: 247, g: 247, b: 247, a: 1)
            let btn = BaseButton(type: .custom)
            btn.titleLabel?.font = font
            btn.layer.cornerRadius = bh*0.5
            btn.layer.masksToBounds = true
            btn.backgroundColor = bgColor
            btn.setTitleColor(color, for: .normal)
            btn.setTitle(title, for: .normal)
            btn.addTarget(self, action: #selector(emptyEvent), for: .touchUpInside)
            scene.addSubview(btn)
            btn.snp.makeConstraints { (m) in
                m.top.equalTo(lab.snp.bottom).offset(HorizontalOffset)
                m.centerX.equalToSuperview()
                m.width.equalTo(bw)
                m.height.equalTo(bh)
            }
        }
        return scene
    }
    @objc private func emptyEvent() {
        callback?()
    }
}
