//
//  KitsCordova.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/6.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation
import SSZipArchive

#if DEBUG
public let APP_ENV = "dev"
public let APP_HOST = "http://ost.x16.com/open/res"
#else
public let APP_ENV = "prod"
public let APP_HOST = "http://ost.x16.com/open/res"
#endif

// MARK: - Kits Extension For Cordova
public extension Kits {
    
    /// prepare env
    public static func cdv_configureEnv(_ token: String) {
        PluginEnv.storeValuve(APP_ENV, forKey: "env")
        PluginEnv.storeValuve(APP_HOST, forKey: "webServer")
        PluginEnv.storeValuve(token, forKey: "sessionToken")
    }
    
    /// codorva path
    private static func cdv_zipBundlePath() -> String? {
        guard let p = Bundle.main.path(forResource: "www", ofType: "zip") else {
            return nil
        }
        return p
    }
    private static func cdv_zipDiskPath() -> String {
        let sandbox = locatePath(.root)
        return sandbox + "/www.zip"
    }
    private static func cdv_runPath() -> String {
        let sandbox = locatePath(.root)
        return sandbox + "/www"
    }
    
    /// zip/unzip
    public static func prepareCordovaRunTime() {
        let f = FileManager.default
        let runPath = cdv_runPath()
        guard f.fileExists(atPath: runPath) == false else {
            debugPrint("cordova资源已经解压，无需再解压")
            return
        }
        /// coping
        let resPath = cdv_zipDiskPath()
        if f.fileExists(atPath: resPath) == false {
            debugPrint("cordova还未Copy到沙盒，Coping...")
            guard let bPath = cdv_zipBundlePath() else {
                debugPrint("Bundle未发现Cordova资源！")
                return
            }
            do {
                let b = URL(fileURLWithPath: bPath)
                let d = URL(fileURLWithPath: resPath)
                try f.copyItem(at: b, to: d)
            } catch {
                debugPrint("copy error:\(error.localizedDescription)")
                return
            }
        }
        
        /// unzip
        let root = locatePath(.root)
        let ret = SSZipArchive.unzipFile(atPath: resPath, toDestination: root)
        debugPrint("unzip result:\(ret)")
    }
    
    /// update logics
    private static func cdv_currentVersion() -> Int {
        let f = FileManager.default
        let runPath = cdv_runPath()
        guard f.fileExists(atPath: runPath) else {
            debugPrint("could found cordova www")
            return -1
        }
        let file = runPath + "/version.json"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
            debugPrint("failed to read file from disk!")
            return -1
        }
        guard let map:NSDictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary else {
            debugPrint("fialed on parser json!")
            return -1
        }
        let v = map.object(forKey: "version") as! Int
        return v
    }
    public static func cdv_update() {
        let old = cdv_currentVersion()
        guard old > 0 else {
            debugPrint("invalid version code!")
            return
        }
        debugPrint("currend cdv version:\(old)")
        //FIXME: fetch newest version for Cordova
        let uri = URL(string: "ss")
        let cfg = URLSessionConfiguration.default
        let session = URLSession(configuration: cfg)
        let task = session.dataTask(with: uri!) { (data, response, error) in
            
        }
        task.resume()
    }
    private static func cdv_loadNewest(_ uriString: String) {
        guard let uri = URL(string: uriString) else {
            debugPrint("unavailable uri for cordova")
            return
        }
        let cfg = URLSessionConfiguration.default
        let session = URLSession(configuration: cfg)
        let task = session.downloadTask(with: uri) { (location, response, error) in
            if let e = error {
                debugPrint("failed to download:\(e.localizedDescription)")
            } else {
                if let uri = location {
                    cdv_replace(uri)
                }
            }
        }
        task.resume()
    }
    private static func cdv_replace(_ with:URL) {
        let f = FileManager.default
        /// old zip resource
        let disk = cdv_zipDiskPath()
        let destUri = URL(fileURLWithPath: disk)
        if f.fileExists(atPath: disk) {
            debugPrint("cdv old resource, removing...")
            do {
                try f.removeItem(at: destUri)
            } catch {
                debugPrint("removing old resource failed!\(error.localizedDescription)")
            }
        }
        /// write new resource
        do {
            try f.copyItem(at: with, to: destUri)
        } catch {
            debugPrint("failed to moving....\(error.localizedDescription)")
        }
        /// unzip
        let run = cdv_runPath()
        _ = SSZipArchive.unzipFile(atPath: disk, toDestination: run)
        debugPrint("cdv done.")
    }
}
