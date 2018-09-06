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


// MARK: - 方式1
public class EmptyDataSource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    /*singletone method
     static let shared = VMEmpty()
     private override init() {
     super.init()
     }*/
    
    typealias emptyShouldDisplay = () -> Bool
    var shouldDisplay: emptyShouldDisplay?
    typealias emptyDisplayDescription = ()->String
    var displayDescription: emptyDisplayDescription?
    typealias emptyPlaceholderTrigger = () -> Void
    var didTrigger: emptyPlaceholderTrigger?
    
    // MARK: empty delegate & dataSource
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        guard shouldDisplay != nil else {
            return true
        }
        return shouldDisplay!()
    }
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        guard let icon = UIImage(named: EmptyImageName) else {
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
        guard SBHTTPRouter.shared.isReachable() else {
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
}

// MARK: - 方式2
//public extension BaseTableView {
//    public func empty(_ title: String, with description: String, icon: String="emptyDataSource", height: CGFloat=300) {
//        let footer = assemble(title, with: description, icon: icon, height: height)
//        tableFooterView = footer
//    }
//    private func assemble(_ title: String, with description: String, icon: String="emptyDataSource", height: CGFloat=300) -> UIView {
//        let b = CGRect(x: 0, y: 0, width: AppSize.WIDTH_SCREEN, height: height)
//        let scene = BaseScene(frame: b)
//        //TODO:subviews
//        return scene
//    }
//    @objc private func emptyEvent() {
//        callback?()
//    }
//}
