//
//  PluginEnv.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/6.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Cordova
import Foundation

@objc(PluginEnv) public class PluginEnv: CDVPlugin {
    static var envMap:[String:String] = [String:String]()
    
    public static func storeValuve(_ value: String, forKey key: String) {
        envMap[key] = value
    }
    
    @objc public func getEnvData(_ command: CDVInvokedUrlCommand) {
        self.commandDelegate.run {
            let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: PluginEnv.envMap)
            self.commandDelegate.send(result, callbackId: command.callbackId)
        }
    }
}
