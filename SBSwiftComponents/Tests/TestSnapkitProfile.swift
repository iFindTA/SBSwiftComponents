//
//  TestSnapkitProfile.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/10/11.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import SnapKit

extension TestSnapkitProfile: SBSceneRouteable {
    static func __init(_ params: SBSceneRouteParameter?) -> UIViewController {
        return TestSnapkitProfile(params)
    }
}

class TestSnapkitProfile: BaseProfile {
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
        
        let bounds = CGRect(x: 0, y: 100, width: AppSize.WIDTH_SCREEN, height: 200)
        let scene = BaseScene(frame: bounds)
        scene.backgroundColor = UIColor.sb_randomColor()
        view.addSubview(scene)
        
        var arr: Array<ConstraintView> = []
        for _ in 0..<5 {
            let subview = UIButton()
            subview.addTarget(self, action: #selector(testTouch), for: .touchUpInside)
            subview.backgroundColor = UIColor.sb_randomColor()
            scene.addSubview(subview)
            arr.append(subview)
        }
        arr.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 10, leadSpacing: 10, tailSpacing: 10)
        arr.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.height.equalTo(150)
        }
        //固定间距,可变大小,上下左右间距默认为0,可以设置
        //arr.snp.distributeSudokuViews(fixedLineSpacing: 10, fixedInteritemSpacing: 10, warpCount: 3)
    }
    
    @objc private func testTouch() {
        debugPrint("touched")
    }
}