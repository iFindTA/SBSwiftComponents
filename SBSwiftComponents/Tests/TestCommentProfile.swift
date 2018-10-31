//
//  TestCommentProfile.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/10/31.
//  Copyright © 2018 nanhu. All rights reserved.
//

import Foundation

class TestCommentProfile: BaseProfile {
    
    /// lazy vars
    private lazy var commentScene: CommentOnScene = {
        let offset = AppSize.HEIGHT_INVALID_BOTTOM()
        let p = CommentOnScene.com(nil, bottom: offset)
        return p
    }()
    
    private var params: SBSceneRouteParameter?
    init(_ parameters: SBSceneRouteParameter?) {
        super.init(nibName: nil, bundle: nil)
        params  = parameters
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // comment
        view.addSubview(commentScene)
        
        /// navigation bar
        view.addSubview(navigationBar)
        let spacer = Kits.barSpacer()
        let backer = Kits.defaultBackBarItem(self, action: #selector(defaultGobackStack))
        let item = UINavigationItem(title: "全部评论")
        item.leftBarButtonItems = [spacer, backer]
        navigationBar.pushItem(item, animated: true)
        
        let b = BaseButton(type: .custom)
        b.setTitle("comment", for: .normal)
        b.setTitleColor(UIColor.blue, for: .normal)
        b.backgroundColor = UIColor.white
        b.addTarget(self, action: #selector(willCommentOn), for: .touchUpInside)
        view.addSubview(b)
        b.snp.makeConstraints { (m) in
            m.top.equalTo(navigationBar.snp.bottom).offset(HorizontalOffsetMAX)
            m.left.right.equalToSuperview()
            m.height.equalTo(AppSize.HEIGHT_ICON)
        }
    }
    
    @objc private func willCommentOn() {
        commentScene.show()
    }
}
extension TestCommentProfile: SBSceneRouteable {
    static func __init(_ params: SBSceneRouteParameter?) -> UIViewController {
        return TestCommentProfile(params)
    }
}
