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
    
    private var label: BaseLabel = {
        let l = BaseLabel(frame: .zero)
        l.font = AppFont.pingFangSC(AppFont.SIZE_TITLE)
        l.textAlignment = .center
        l.textColor = AppColor.COLOR_TITLE
        l.text = "该服务目前不可用！"
        return l
    }()
    
    init(_ parameters: SBSceneRouteParameter?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.label)
        self.label.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
}

extension SB404: SBSceneRouteable {
    static func __init(_ params: SBSceneRouteParameter?) -> UIViewController {
        return SB404(params)
    }
}
