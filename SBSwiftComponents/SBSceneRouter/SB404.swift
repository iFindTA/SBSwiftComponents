//
//  SB404.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/5.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import Foundation

public class SB404: BaseProfile {
    
    private lazy var label: BaseLabel = {
        let l = BaseLabel(frame: .zero)
        l.font = AppFont.pingFangSC(AppFont.SIZE_TITLE)
        l.textAlignment = .center
        l.textColor = AppColor.COLOR_TITLE
        l.text = "该服务飞到火星了，请稍后再来！"
        return l
    }()
    private lazy var backBarButtonItem: UIBarButtonItem =  {
        var tempBackBarButtonItem = UIBarButtonItem(image: WebBrowser.bundledImage(named: "browser_icon_back"),
                                                    style: UIBarButtonItemStyle.plain,
                                                    target: self,
                                                    action: #selector(defaultGobackStack))
        tempBackBarButtonItem.width = 18.0
        tempBackBarButtonItem.tintColor = nil
        return tempBackBarButtonItem
    }()
    
    init(_ parameters: SBSceneRouteParameter?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navigationBar)
        let item = UINavigationItem(title: "Oops")
        item.leftBarButtonItem = backBarButtonItem
        navigationBar.pushItem(item, animated: true)
        
        view.insertSubview(label, belowSubview: navigationBar)
        self.label.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
}

extension SB404: SBSceneRouteable {
    public static func __init(_ params: SBSceneRouteParameter?) -> UIViewController {
        return SB404(params)
    }
}
