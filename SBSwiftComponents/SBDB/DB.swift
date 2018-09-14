//
//  DB.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/6.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import SQLite
import Foundation

public extension Connection {
    public func tableExists(_ tableName: String) -> Bool {
        guard let count = try? self.scalar("SELECT EXISTS(SELECT name FROM sqlite_master WHERE name = ?)", tableName) as! Int64, count > 0 else {
            return false
        }
        return true
    }
}

public class DB {
    /// Variables
    private static var dbConne: Connection!
    
    /// getter
    private static func db_dir() -> String {
        let docPath = Kits.locatePath(.common)
        let dbPath = docPath + "/dbs/"
        return dbPath
    }
    private static func db_path() -> String {
        let dir = db_dir()
        return dir + "_caches.db"
    }
    public class func getDB() -> Connection? {
        return dbConne
    }
    public class func resetDB() {
        dbConne = nil
    }
    
    /// setup
    public class func setup() {
        guard getDB() == nil else {
            debugPrint("db connection still alive!")
            return
        }
        let dir = db_dir()
        let f = FileManager.default
        if f.fileExists(atPath: dir) == false {
            do {
                let uri = URL(fileURLWithPath: dir)
                try f.createDirectory(at: uri, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint("failed to create db path!\(error.localizedDescription)")
            }
        }
        let full = db_path()
        dbConne = try! Connection(full)
        #if DEBUG
        dbConne.trace { (sql) in
            debugPrint(sql)
        }
        #endif
        migrates()
        debugPrint("create db connection done.")
    }
    public class func migrates() {
        //TODO:需要被子类覆盖此方法
    }
}
