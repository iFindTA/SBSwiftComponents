//
//  CommentOnScene.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/10/31.
//  Copyright © 2018 nanhu. All rights reserved.
//

import SDWebImage
import Foundation
import IQKeyboardManagerSwift

fileprivate let kInputFont = UIFont.systemFont(ofSize: 13)
fileprivate let kOffsetVertical: CGFloat = 7
fileprivate let kOffsetHorizontal: CGFloat = 5
fileprivate let kChatActionBarOriginalHeight: CGFloat = 50      //ActionBar orginal height
fileprivate let kChatActionBarTextViewMaxHeight: CGFloat = 120   //Expandable textview max height

/// 全局评论scene（回复、评论）
class CommentOnScene: BaseScene {
    /// vars
    public var callback: StringClosure?
    //private var fatherView: UIView?
    private var inputBarHeight: CGFloat = kChatActionBarOriginalHeight
    private var inputBarBottomOffsetActive: CGFloat = 0 /// 激活状态offset
    private var inputBarBottomOffsetNormal: CGFloat = AppSize.HEIGHT_INVALID_BOTTOM()///正常情况offset
    private var inputBarActived: Bool = false
    /// lazy vars
    private lazy var inputBar: ComInputBar = {
        let s = ComInputBar(frame: .zero)
        return s
    }()
    private lazy var maskScene: BaseScene = {
        let s = BaseScene(frame: .zero)
        s.backgroundColor = ClearBgColor
        return s
    }()
    private lazy var bottomScene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    
    /// getters
    class func com(_ father: UIView?, bottom offset: CGFloat) -> CommentOnScene {
        return CommentOnScene(father, bottom: offset)
    }
    fileprivate class func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return UIImage(named: named, in: Bundle(for: CommentOnScene.classForCoder()), compatibleWith: nil)
        }
        return image
    }
    init(_ father: UIView?, bottom offset: CGFloat) {
        super.init(frame: .zero)
        inputBarBottomOffsetNormal = offset
        //addSubview(maskScene)
        addSubview(inputBar)
        addSubview(bottomScene)
        inputBar.input.delegate = self
        inputBar.callback = {[weak self] in
            self?.willRelease()
        }
        backgroundColor = ClearBgColor
        installKeyboardObserves()
    }
    deinit {
        unInstallKeyboardObserves()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let bh = max(0, inputBarBottomOffsetNormal)
        bottomScene.snp.makeConstraints { (m) in
            m.left.bottom.right.equalToSuperview()
            m.height.equalTo(bh)
        }
        inputBar.snp.removeConstraints()
        let offset = inputBarActived ? inputBarBottomOffsetActive : inputBarBottomOffsetNormal
        inputBar.snp.makeConstraints { (m) in
            m.left.right.equalToSuperview()
            m.bottom.equalToSuperview().offset(-offset)
            m.height.equalTo(inputBarHeight)
        }
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview == nil else {
            IQKeyboardManager.shared.enable = false
            IQKeyboardManager.shared.enableAutoToolbar = false
            return
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else {
            return
        }
        self.snp.removeConstraints()
        self.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    /// events
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        dismiss()
    }
    
    /// outter
    public func configure(_ uri: URL?, with placeholder: String?="说点什么吧...") {
        inputBar.update(uri, with: placeholder)
    }
    public func show() {
        guard inputBarActived == false else {
            return
        }
        inputBar.focusOn()
    }
    public func dismiss() {
        guard inputBarActived == true else {
            return
        }
        inputBar.focusOff()
    }
    
    private func willRelease() {
        let inputs = inputBar.input.text
        guard inputs?.isEmpty == false else {
            Kits.makeToast("说点什么吧...")
            return
        }
        dismiss()
        callback?(inputs!)
    }
}
// MARK: - Keyboard Observes
extension CommentOnScene {
    /// keyboard
    private func installKeyboardObserves() {
        NotificationCenter.default.addObserver(self, selector: #selector(__keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(__keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    private func unInstallKeyboardObserves() {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func __keyboardWillShow(_ notify: NSNotification) {
        guard inputBarActived == false else {
            debugPrint("this was disappear, should not respond")
            return
        }
        __kbDidChanged(notify, with: true)
    }
    @objc private func __keyboardWillHide(_ notify: NSNotification) {
        guard inputBarActived == true else {
            return
        }
        __kbDidChanged(notify, with: false)
    }
    private func __kbDidChanged(_ notify: NSNotification, with show: Bool) {
        if show {
            forewardHierarchy()
        } else {
            inputBar.input.text = nil
            inputBarHeight = kChatActionBarOriginalHeight
        }
        inputBarActived = show
        
        var userInfo = notify.userInfo!
        let kbRect = userInfo[UIKeyboardFrameEndUserInfoKey]! as! CGRect
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]! as! UInt
        let convertedFrame = convert(kbRect, from: nil)
        let opts = UIViewAnimationOptions(rawValue: curve << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]! as! Double
        inputBarBottomOffsetActive = show ? (bounds.height - convertedFrame.origin.y) : 0
        /// animation
        UIView.animate(withDuration: duration, delay: 0, options: opts, animations: {[weak self] in
            self?.setNeedsLayout()
            self?.layoutIfNeeded()
        }) { [weak self](f) in
            guard f == true, show == false else {
                return
            }
            self?.backwardHierarchy()
        }
    }
    private func backwardHierarchy() {
        superview?.sendSubview(toBack: self)
    }
    private func forewardHierarchy() {
        superview?.bringSubview(toFront: self)
    }
}

// MARK: - Delegate
extension CommentOnScene: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            willRelease()
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        let contentH = textView.contentSize.height
        guard contentH < kChatActionBarTextViewMaxHeight else {
            return
        }
        let inputHeight = contentH + 17
        let fixedHeight = max(inputHeight, kChatActionBarOriginalHeight)
        guard fixedHeight != inputBarHeight else {
            return
        }
        inputBarHeight = fixedHeight
        UIView.animate(withDuration: Macros.APP_ANIMATE_INTERVAL) {[weak self] in
            self?.setNeedsLayout()
            self?.layoutIfNeeded()
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.setAnimationsEnabled(false)
        let range = NSMakeRange(textView.text.count - 1, 1)
        textView.scrollRangeToVisible(range)
        UIView.setAnimationsEnabled(true)
        return true
    }
}

/// input panel
fileprivate class ComInputBar: BaseScene {
    /// vars
    public var callback: VoidClosure?
    /// lazy vars
    private lazy var scene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    private lazy var releaseBtn: BaseButton = {
        let icon = CommentOnScene.bundledImage(named: "icon_scene_com_release")
        let b = BaseButton(type: .custom)
        b.setImage(icon, for: .normal)
        b.addTarget(self, action: #selector(willRelease), for: .touchUpInside)
        return b
    }()
    public lazy var input: IQTextView = {
        let i = IQTextView(frame: .zero)
        i.textColor = AppColor.COLOR_TITLE
        i.placeholderTextColor = AppColor.COLOR_TITLE_LIGHTGRAY
        i.placeholder = "说点什么吧..."
        i.font = kInputFont
        i.layer.borderColor = RGBA(r: 218, g: 218, b: 218, a: 1).cgColor
        i.layer.borderWidth = 1
        i.layer.cornerRadius = kOffsetHorizontal
        i.scrollsToTop = false
        i.textContainerInset = UIEdgeInsetsMake(9, kOffsetHorizontal, kOffsetHorizontal, kOffsetHorizontal)
        i.returnKeyType = .send
        i.enablesReturnKeyAutomatically = true
        i.layoutManager.allowsNonContiguousLayout = false
        return i
    }()
    private lazy var inputScene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    private lazy var iconScene: BaseScene = {
        let s = BaseScene(frame: .zero)
        return s
    }()
    private lazy var iconView: BaseImageView = {
        let i = BaseImageView(frame: .zero)
        i.backgroundColor = AppColor.COLOR_BG_GRAY
        return i
    }()
    private lazy var iconMask: UIImageView = {
        let i = UIImageView(frame: .zero)
        i.image = CommentOnScene.bundledImage(named: "icon_scene_com_usrmask")
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scene)
        scene.addSubview(iconScene)
        iconScene.addSubview(iconView)
        iconScene.addSubview(iconMask)
        scene.addSubview(releaseBtn)
        scene.addSubview(inputScene)
        inputScene.addSubview(input)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        scene.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        let isize = kChatActionBarOriginalHeight-kOffsetVertical*2
        iconScene.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().offset(kOffsetHorizontal)
            m.width.height.equalTo(isize)
        }
        iconView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        iconMask.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        releaseBtn.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.right.equalToSuperview().offset(-kOffsetHorizontal)
            m.width.height.equalTo(isize)
        }
        inputScene.snp.makeConstraints { (m) in
            m.top.bottom.equalToSuperview()
            m.left.equalTo(iconScene.snp.right)
            m.right.equalTo(releaseBtn.snp.left)
        }
        let insets = UIEdgeInsetsMake(kOffsetVertical, kOffsetVertical, kOffsetVertical, kOffsetVertical)
        input.snp.makeConstraints { (m) in
            m.edges.equalToSuperview().inset(insets)
        }
    }
    public func update(_ uri: URL?, with placeholder: String?="说点什么吧...") {
        iconView.sd_setImage(with: uri, completed: nil)
        input.placeholder = placeholder
    }
    public func focusOn() {
        input.becomeFirstResponder()
    }
    public func focusOff() {
        input.resignFirstResponder()
    }
    @objc private func willRelease() {
        callback?()
    }
}
