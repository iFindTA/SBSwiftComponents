//
//  FileStreamer.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/10/17.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit

public enum FileState: Int {
    case idle
    case pause
    case failed
    case finished
    case transferring
}

public class File {
    ///
    private var task: URLSessionDataTask?
    fileprivate let session: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 60
        cfg.requestCachePolicy = .useProtocolCachePolicy
        let s = URLSession(configuration: cfg)
        return s
    }()
    /// 文件传输c状态
    public var state: FileState = .idle
    /// 文件key
    public var key: String = ""
    public var uriString: String = ""
    public var progress: CGFloat = 0
    public var lenTotal: Int = 0
    public var lenCurrent: Int = 0
    public func savingPath() -> String {
        let previous = Kits.locatePath(.file)
        return "\(previous)/\(key)"
    }
    
    public static func file(_ key: String, fullUri uri: String) -> File {
        return File(key, fullUri: uri)
    }
    private init(_ key: String, fullUri uri: String) {
        self.key = key
        self.uriString = uri
    }
    
    /// getters
    private func fetchCached() -> Int {
        var cs: Int = 0
        let m = FileManager.default
        let path = savingPath()
        if m.fileExists(atPath: path) {
            do {
                let attr = try m.attributesOfItem(atPath: path)
                cs = attr[FileAttributeKey.size] as? Int ?? 0
            } catch {
                debugPrint("failed on fetch attr on file: \(key), with error:\(error.localizedDescription)")
            }
        }
        return cs
    }
    private func fetchTask() -> URLSessionDataTask? {
        if let t = task {
            return t
        }
        guard key.count > 0, uriString.count > 0, let uri = URL(string: uriString) else {
            debugPrint("empty uri or key for file!")
            return nil
        }
        /// cached
        lenCurrent = self.fetchCached()
        
        let t = session.dataTask(with: uri) { (data, response, error) in
            
        }
        task = t
        return t
    }
}
extension File {
    
}

/// 文件下载类
public class FileStreamer: NSObject {
    public static let shared = FileStreamer()
    private override init() {}
    
    /// events
    public func pause(_ key: String) ->BaseError? {
        return nil
    }
    public func cancel(_ key: [String]) ->BaseError? {
        return nil
    }
    public func resume(_ key: String) ->BaseError? {
        return nil
    }
    public func download(_ files: [File]?) {
        
    }
}
