//
//  ViewController.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import SnapKit
import Toaster

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn = BaseButton(type: .custom)
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
        
        
    }
    
    @objc private func fetchTest() {
        Kits.makeToast("test show")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

