//
//  ViewController.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: BaseProfile {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var btn = BaseButton(type: .custom)
        btn.setTitle("test api", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(fetchTest), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppSize.HEIGHT_SUBBAR)
        }
        
        let input = BaseTextField(frame: .zero)
        input.placeholder = "input something"
        view.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.top.equalTo(btn.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppSize.HEIGHT_ICON)
        }
        
        let snapKit = BaseButton(type: .custom)
        snapKit.setTitle("test snapkit", for: .normal)
        snapKit.setTitleColor(UIColor.blue, for: .normal)
        snapKit.addTarget(self, action: #selector(testSnapkit), for: .touchUpInside)
        view.addSubview(snapKit)
        snapKit.snp.makeConstraints { (make) in
            make.top.equalTo(input.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppSize.HEIGHT_SUBBAR)
        }
        
        let load = BaseButton(type: .custom)
        load.setTitle("test baseloading", for: .normal)
        load.setTitleColor(UIColor.blue, for: .normal)
        load.addTarget(self, action: #selector(testBaseloading), for: .touchUpInside)
        view.addSubview(load)
        load.snp.makeConstraints { (make) in
            make.top.equalTo(snapKit.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppSize.HEIGHT_SUBBAR)
        }
        
        let state = BaseButton(type: .custom)
        state.setTitle("test state", for: .normal)
        state.setTitleColor(UIColor.blue, for: .normal)
        state.addTarget(self, action: #selector(testState(_:)), for: .touchUpInside)
        view.addSubview(state)
        state.snp.makeConstraints { (make) in
            make.top.equalTo(load.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppSize.HEIGHT_SUBBAR)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func fetchTest() {
        let err = SBSceneRouter.route2(TestPaths.api)
        Kits.handleError(err)
    }
    
    @objc private func testSnapkit() {
        let err = SBSceneRouter.route2(TestPaths.snapkit)
        Kits.handleError(err)
    }
    
    @objc private func testBaseloading() {
        BaseLoading.shared.showIn(view)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            BaseLoading.shared.hide()
        }
    }
    
    @objc private func testState(_ btn: BaseButton) {
        btn.sb_busyState = true
        btn.appearState = .loading
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            btn.sb_busyState = false
            btn.appearState = .idle
        }
        Kits.makeToast("test for sb toaster")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

