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
public let HorizontalOffset = AppSize.WIDTH_MARGIN
public let HorizontalOffsetMAX = AppSize.WIDTH_BOUNDARY
public let SeperatorBgColor = RGBA(r: 244, g: 243, b: 245, a: 1)
public let ClearBgColor = UIColor(white: 0, alpha: 0.3)

// MARK: - UIButton类
public class BaseButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public init(type buttonType: UIButtonType) {
        super.init(frame: .zero)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let preEventStamp = self.sb_acceptEventTime
        let duration = self.sb_acceptEventInterval
        let curEventStamp = Date().timeIntervalSince1970
        if abs(preEventStamp - curEventStamp) > duration {
            super.touchesBegan(touches, with: event)
        }
        self.sb_acceptEventTime = curEventStamp
    }
    
    public var extendTag: Int = 0//扩展的属性 方便操作
}

// MARK: - UILbel类
public class BaseLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.white
    }
}

// MARK: - UIImageView类
public class BaseImageView: UIImageView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentMode = .scaleToFill
        backgroundColor = UIColor.white
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - UIScrollView类
public class BaseScrollView: UIScrollView {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
}
public extension BaseScrollView {
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
public class BaseTableView: UITableView {
    /// callback
    public var callback: VoidClosure?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
}
public extension BaseTableView {
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

// MARK: - UITableViewCell
open class BaseCell: UITableViewCell {
    public lazy var scene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    public lazy var iconScene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    public lazy var textScene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    public lazy var iconView: BaseImageView = {
        let s = BaseImageView(frame: .zero)
        return s
    }()
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(scene)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        scene.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
}

// MARK: - UITextField
public class BaseTextField: UITextField {
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingDidChanged(_:)), for: .editingChanged)
        editingDidChanged(self)
    }
    @objc func editingDidChanged(_ textFiled: UITextField) {
        guard let text = textFiled.text else {
            return
        }
        let max = textFiled.sb_maxLength
        let lang = textFiled.textInputMode?.primaryLanguage
        
        if let lan = lang, lan == "zh-Hans" {
            let range = textFiled.markedTextRange
            if range == nil {
                if text.count >= max {
                    textFiled.text = String(text.prefix(max))
                }
            }
        } else {
            textFiled.text = String(text.prefix(max))
        }
    }
}

// MARK: - UIView
open class BaseScene: UIView {
    /// Variables
    public var sectionTag: Int = 0
    
    deinit {
        print("scene 析构: class: \(type(of: self))")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview == nil else {
            return
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    public func stopAllRequest() {
        let this = NSStringFromClass(type(of: self))
        let tmp = this as NSString
        guard tmp.range(of: ".").location == NSNotFound else {
            let range = tmp.range(of: ".", options: .backwards)
            let nr = tmp.substring(with: NSMakeRange(range.location+1, this.count-range.location-range.length))
            SBHTTPRouter.shared.cancel(nr)
            return
        }
        SBHTTPRouter.shared.cancel(this)
    }
}

// MARK: - UINavigationBar
public class BaseNavigationBar: UINavigationBar {
    var offset:CGFloat {
        guard UIDevice.current.isX() else {
            return 0
        }
        return 30
    }
    //*
    override public func layoutSubviews() {
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

// MARK: - mask present弹出遮罩 base
open class BaseMaskScene: BaseScene {
    /// vars
    private weak var fatherScene: UIView?
    private var topOffset: CGFloat = 0
    private var availableHeight: CGFloat = 0///info scene
    private var whetherDisplay: Bool = false
    
    /// lazy vars
    public lazy var scene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    public lazy var closeBtn: BaseButton = {
        let color = AppColor.COLOR_TITLE_GRAY
        let font = AppFont.iconFont(AppFont.SIZE_LARGE_TITLE)
        let b = BaseButton(type: .custom)
        b.titleLabel?.font = font
        b.setTitleColor(color, for: .normal)
        b.setTitle("\u{e605}", for: .normal)
        b.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return b
    }()
    
    /* init
    public class func mask(_ father: UIView, top offset: CGFloat, with bottom: CGFloat=0) -> BaseMaskScene {
        return BaseMaskScene(father, top: offset, with: bottom)
    }
    */
    public init(_ father: UIView?, top offset: CGFloat, with bottom: CGFloat=0) {
        super.init(frame: .zero)
        fatherScene = father
        topOffset = offset
        availableHeight = AppSize.HEIGHT_SCREEN - offset - bottom
        /// custom
        isHidden = true
        backgroundColor = ClearBgColor
        father?.addSubview(self)
        self.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        /// subviews
        addSubview(scene)
        scene.addSubview(closeBtn)
        let of = fetchEndFrame()
        scene.frame = of
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// getter
    private func fetchEndFrame() -> CGRect {
        let top = whetherDisplay ? topOffset : AppSize.HEIGHT_SCREEN
        return CGRect(x: 0, y: top, width: AppSize.WIDTH_SCREEN, height: availableHeight)
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        closeBtn.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(HorizontalOffset)
            m.right.equalToSuperview().offset(-HorizontalOffset)
        }
    }
    /// events
    open func show() {
        whetherDisplay.toggle()
        isHidden = false
        fatherScene?.bringSubview(toFront: self)
        updateScenePosition()
    }
    @objc public func dismiss() {
        whetherDisplay.toggle()
        updateScenePosition()
        didDisappear()
    }
    open func didDisappear() {
        
    }
    private func updateScenePosition() {
        let to = fetchEndFrame()
        UIView.animate(withDuration: Macros.APP_ANIMATE_INTERVAL, animations: {[weak self] in
            self?.scene.frame = to
        }) { [weak self](f) in
            self?.isHidden = !(self?.whetherDisplay ?? true)
        }
    }
}

// MARK: - mask 缩放居中弹窗
open class BaseCenterMaskScene: BaseScene {
    /// vars
    private weak var fatherScene: UIView?
    private var availableHeight: CGFloat = 0///info scene
    private var whetherThisDisplay: Bool = false
    private var whetherShowClose: Bool = true///是否现实close&line
    /// lazy vars
    public lazy var scene: BaseScene = {
        let s = BaseScene(frame: .zero)
        s.clipsToBounds = true
        s.layer.masksToBounds = true
        s.layer.cornerRadius = AppSize.RADIUS_NORMAL
        return s
    }()
    private let lineColor = UIColor.white
    public lazy var closeBtn: BaseButton = {
        let font = AppFont.iconFont(AppFont.SIZE_TITLE*2)
        let b = BaseButton(type: .custom)
        b.isHidden = true
        b.titleLabel?.font = font
        b.setTitleColor(lineColor, for: .normal)
        b.setTitle("\u{e6c0}", for: .normal)
        b.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return b
    }()
    public lazy var line: BaseScene = {
        let s = BaseScene(frame: .zero)
        s.isHidden = true
        s.backgroundColor = lineColor
        return s
    }()
    
    public init(_ father: UIView?, whether showClose: Bool=true, available height: CGFloat=AppSize.WIDTH_SCREEN) {
        super.init(frame: .zero)
        fatherScene = father
        availableHeight = height
        whetherShowClose = showClose
        /// custom
        isHidden = true
        backgroundColor = ClearBgColor
        father?.addSubview(self)
        self.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        /// subviews
        addSubview(scene)
        addSubview(line)
        addSubview(closeBtn)
        let of = fetchEndFrame()
        scene.frame = of
        scene.transform = CGAffineTransform(scaleX: 1, y: 0.01)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// getter
    private func fetchEndFrame() -> CGRect {
        let offset = HorizontalOffsetMAX*2
        let top = (AppSize.HEIGHT_SCREEN-availableHeight)*0.5
        return CGRect(x: offset, y: top, width: AppSize.WIDTH_SCREEN-offset*2, height: availableHeight)
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        let offset = AppSize.SIZE_OFFSET
        line.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(scene.snp.bottom)
            m.width.equalTo(1)
            m.height.equalTo(AppSize.HEIGHT_ICON*2)
        }
        closeBtn.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(line.snp.bottom).offset(-offset*3)
        }
    }
    /// events
    public func show() {
        whetherThisDisplay.toggle()
        isHidden = false
        fatherScene?.bringSubview(toFront: self)
        updateSceneTransform()
    }
    @objc public func dismiss() {
        whetherThisDisplay.toggle()
        updateHiddenStates()
        updateSceneTransform()
        didDisappear()
    }
    open func didDisappear() {
        
    }
    private func updateHiddenStates() {
        guard whetherShowClose == true else {
            return
        }
        self.line.isHidden = !whetherThisDisplay
        self.closeBtn.isHidden = !whetherThisDisplay
    }
    private func updateSceneTransform() {
        let to = whetherThisDisplay ? CGAffineTransform.identity : CGAffineTransform(scaleX: 1, y: 0.01)
        UIView.animate(withDuration: Macros.APP_ANIMATE_INTERVAL, animations: {[weak self] in
            self?.scene.transform = to
        }) { [weak self](f) in
            if f && self?.whetherThisDisplay == true {
                self?.updateHiddenStates()
            } else {
                self?.isHidden = true
            }
        }
    }
}

// MARK: - base loading
public class BaseLoading: BaseScene {
    /// lazy vars
    private lazy var acter: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        a.hidesWhenStopped = true
        return a
    }()
    public static let shared = BaseLoading(frame: .zero)
    private override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        addSubview(acter)
    }
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        acter.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
        }
    }
    public func showIn(_ view: UIView!) {
        isHidden = false
        if let father = view {
            acter.startAnimating()
            father.addSubview(self)
            self.snp.removeConstraints()
            self.snp.makeConstraints { (m) in
                m.edges.equalToSuperview()
            }
        }
    }
    public func hide(_ hide: Bool=true) {
        acter.stopAnimating()
        guard hide == true else {
            return
        }
        isHidden = true
        removeFromSuperview()
    }
}
