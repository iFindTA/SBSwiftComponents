//
//  TestEmptyProfile.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/19.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
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
        /// method 1
//        table.emptyDataSetSource = empty
//        table.emptyDataSetDelegate = empty
//        empty.shouldDisplay = {()->Bool in
//            return true
//        }
        
        /// method 2
//        table.empty("去评论", with: "还没有人评论，快去抢沙发吧～")
//        table.callback = {
//            debugPrint("empty touched")
//        }
        
        /// method3
        table.delegate = self
        table.dataSource = self
        table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension TestEmptyProfile: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EmptyCell.suggestedHeight()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "empty_cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EmptyCell
        if cell == nil {
            cell = EmptyCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.update("去评论", with: "没有评论，赶快去抢沙发～")
        return cell!
    }
}

extension TestEmptyProfile: SBSceneRouteable {
    static func __init(_ params: SBSceneRouteParameter?) -> UIViewController {
        return TestEmptyProfile(params)
    }
}
