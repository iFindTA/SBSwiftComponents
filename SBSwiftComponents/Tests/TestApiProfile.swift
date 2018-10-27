//
//  TestApiProfile.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/10/27.
//  Copyright © 2018 nanhu. All rights reserved.
//

import Foundation

class TestApiProfile: BaseProfile {
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
        let item = UINavigationItem(title: "Api Cancel test")
        item.leftBarButtonItems = [spacer, backer]
        navigationBar.pushItem(item, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
extension TestApiProfile: SBSceneRouteable {
    static func __init(_ params: SBSceneRouteParameter?) -> UIViewController {
        return TestApiProfile(params)
    }
}
