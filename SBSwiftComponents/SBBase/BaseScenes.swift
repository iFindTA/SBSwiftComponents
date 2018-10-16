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
    /// Variables
    public typealias EmptyCallback = ()->Void
    public var callback: EmptyCallback?
    
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

// MARK: - mask 弹出遮罩 base
open class MaskBaseScene: BaseScene {
    /// vars
    private var fatherScene: UIView?
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
    
    /// init
    class func mask(_ father: UIView, top offset: CGFloat, with bottom: CGFloat=0) -> MaskBaseScene {
        return MaskBaseScene(father, top: offset, with: bottom)
    }
    private init(_ father: UIView, top offset: CGFloat, with bottom: CGFloat=0) {
        super.init(frame: .zero)
        fatherScene = father
        topOffset = offset
        availableHeight = AppSize.HEIGHT_SCREEN - offset - bottom
        /// custom
        isHidden = true
        backgroundColor = ClearBgColor
        father.addSubview(self)
        self.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        /// subviews
        addSubview(scene)
        scene.addSubview(closeBtn)
        let of = fetchEndFrame()
        scene.frame = of
        configureSubviews()
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
    public func configureSubviews() {}/// should be implemented by sub-class
    public func updateDisplay() {}/// should be implemented by sub-class
    
    /// events
    public func show() {
        whetherDisplay.toggle()
        isHidden = false
        updateDisplay()
        fatherScene?.bringSubview(toFront: self)
        updateScenePosition()
    }
    @objc private func dismiss() {
        whetherDisplay.toggle()
        updateScenePosition()
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
