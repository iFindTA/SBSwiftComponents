//
//  TestEmptyProfile.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/19.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation

class TestEmptyProfile: BaseProfile {
    
    /// Variables
    private lazy var empty: EmptyDataSource = {
        let e = EmptyDataSource()
        return e
    }()
    private lazy var table: BaseTableView = {
        let t = BaseTableView(frame: .zero, style: .plain)
        
        t.separatorStyle = .none
        t.tableFooterView = UIView()
        return t
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
        
        view.addSubview(navigationBar)
        let spacer = Kits.barSpacer()
        let backer = Kits.defaultBackBarItem(self, action: #selector(defaultGobackStack))
        let item = UINavigationItem(title: "Empty")
        item.leftBarButtonItems = [spacer, backer]
        navigationBar.pushItem(item, animated: true)
        
        let bottom = AppSize.HEIGHT_INVALID_BOTTOM()
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottom)
        }
        table.emptyDataSetSource = empty
        table.emptyDataSetDelegate = empty
        empty.shouldDisplay = {()->Bool in
            return true
        }
    }
}

extension TestEmptyProfile: SBSceneRouteable {
    static func __init(_ params: SBSceneRouteParameter?) -> UIViewController {
        return TestEmptyProfile(params)
    }
}
