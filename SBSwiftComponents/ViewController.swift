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
        
        btn = BaseButton(type: .custom)
        btn.setTitle("test browser", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(testWebBrowser), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(input.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppSize.HEIGHT_SUBBAR)
        }
        
        let empty = BaseButton(type: .custom)
        empty.setTitle("test empty", for: .normal)
        empty.setTitleColor(UIColor.blue, for: .normal)
        empty.addTarget(self, action: #selector(testEmpty), for: .touchUpInside)
        view.addSubview(empty)
        empty.snp.makeConstraints { (make) in
            make.top.equalTo(btn.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppSize.HEIGHT_SUBBAR)
        }
        
        let wxShare = BaseButton(type: .custom)
        wxShare.setTitle("test share wechat", for: .normal)
        wxShare.setTitleColor(UIColor.blue, for: .normal)
        wxShare.addTarget(self, action: #selector(share2WeChat), for: .touchUpInside)
        view.addSubview(wxShare)
        wxShare.snp.makeConstraints { (make) in
            make.top.equalTo(empty.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppSize.HEIGHT_SUBBAR)
        }
    }
    
    @objc private func fetchTest() {
        Kits.makeToast("test show")
    }
    @objc private func testWebBrowser() {
        var p = SBSceneRouteParameter()
        p["url"] = "https://r.xiumi.us/stage/v5/2nQDs/104736814"
        let browser = WebBrowser(p)
        self.navigationController?.pushViewController(browser, animated: true)
    }
    @objc private func testEmpty() {
        let err = SBSceneRouter.route2(TestPaths.empty)
        Kits.handleError(err)
    }
    
    @objc private func share2WeChat() {
        
        let title = "title for share"
        let desc = "这是一段精彩的描述文档，请具体查看文档"
        let link = "https://github.com/ifindTA/"
        let icon = "http://e.hiphotos.baidu.com/image/pic/item/72f082025aafa40fafb5fbc1a664034f78f019be.jpg"
        TPOpen.shared.shareLink([.qq, .wxSession], title: title, desciption: desc, icon: icon, hybrid: link, profile: self) { (error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

