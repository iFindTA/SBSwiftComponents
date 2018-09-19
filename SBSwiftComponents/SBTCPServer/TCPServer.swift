//
//  TCPServer.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/14.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public let kGENERAL = 0x153
fileprivate let KRetryMaxCount = 5

public typealias TCPConnectResponse = (BaseError?)->Void
public typealias TCPDataResponse = (Data?, BaseError?)->Void
public typealias TCPHeartbeat = ()->Void

public class TCPServer: NSObject {
    
    /// Variables
    private var serverIndex = 0
    private var retryCounts = 0
    private var whetherInitiativeLogout = false
    private var connectionCalback: TCPConnectResponse?
    private var connTimer: Timer?
    
    private lazy var receivedData: NSMutableData = {
        let d = NSMutableData()
        return d
    }()
    private lazy var servers: [[String: Any]] = {
        let s = [[String: Any]]()
        return s
    }()
    public lazy var socket: GCDAsyncSocket = {
        let s = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        s.isIPv4PreferredOverIPv6 = false
        return s
    }()
    
    /// share instance
    public static let shared = TCPServer()
    private override init() {}
    
    /// util
    public func writeRawVarint32(value: inout UInt) -> NSMutableData {
        let mutableData = NSMutableData()
        while true {
            if value & ~0x7F == 0 {
                mutableData.append(Data(bytes: &value, count: 1))
                break
            } else {
                var length: UInt = ((value & 0x7F) | 0x80)
                mutableData.append(Data(bytes: &length, count: 1))
                value >>= 7
            }
        }
        return mutableData
    }
    private func readByte(_ loc: Int, data: inout NSMutableData) -> Int8 {
        var buffer: [Int8] = [0]
        data.getBytes(&buffer, range: NSMakeRange(loc, 1))
        return buffer[0]
    }
    private func readRawVarint32(data: inout NSMutableData) -> NSRange {
        var loc: Int = 0
        if data.length == 0 {
            return NSMakeRange(0, 0)
        }
        loc = loc + 1
        var tmp = readByte(loc, data: &data)
        if tmp >= 0 {
            return NSMakeRange(1, Int(tmp))
        } else {
            var result = tmp&127
            loc = loc + 1
            tmp = readByte(loc, data: &data)
            if tmp >= 0 {
                result |= tmp<<7
            } else {
                result |= (tmp&127)<<7
                loc = loc + 1
                tmp = readByte(loc, data: &data)
                if tmp  >= 0 {
                    result |= tmp<<14
                } else {
                    result |= (tmp&127)<<14
                    loc = loc + 1
                    tmp = readByte(loc, data: &data)
                    if tmp >= 0 {
                        result |= tmp<<21
                    } else {
                        result |= (tmp&127)<<21
                        loc = loc + 1
                        tmp = readByte(loc, data: &data)
                        result |= tmp<<28
                        if tmp < 0 {
                            return NSMakeRange(0, 0)
                        }
                    }
                }
            }
            return NSMakeRange(loc, Int(result))
        }
    }
    
    /// timer
    private func clearTimer() {
        guard let t = connTimer else {
            return
        }
        if t.isValid {
            t.invalidate()
        }
        connTimer = nil
    }
    
    /// heartbeat
    public func sendHeartbeat() {
        //FIXME:此处若是写json则可单独出来
    }
    
    /// outter actions
    public var callback: TCPDataResponse?
    public var heartbeat: TCPHeartbeat?
    public func add(_ host: String, port: UInt16) {
        var map = [String: Any]()
        map["host"] = host
        map["port"] = port
        servers.append(map)
    }
    public func disconnect() {
        whetherInitiativeLogout = true
        socket.disconnect()
    }
    public func connect(completion:@escaping TCPConnectResponse) -> Void {
        guard socket.isConnected == false else {
            debugPrint("tcp is still alived!")
            return
        }
        guard servers.count > 0 else {
            debugPrint("socket套接字服务器地址列表空!")
            return
        }
        /// connect
        let s = servers[serverIndex]
        let host = s["host"] as! String
        let port = s["port"] as! UInt16
        var err: BaseError?
        do {
            try socket.connect(toHost: host, onPort: port)
        } catch {
            err = BaseError(error.localizedDescription)
            debugPrint("failed on connect: \(error.localizedDescription)")
        }
        connectionCalback = completion
        completion(err)
        if err == nil {
            socket.readData(withTimeout: -1, tag: kGENERAL)
        }
    }
}

// MARK: - Socket Delegates
extension TCPServer: GCDAsyncSocketDelegate {
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        debugPrint("TCP已链接：\(host):\(port)")
        serverIndex = 0
        clearTimer()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(retry), object: nil)
        sock.readData(withTimeout: -1, tag: kGENERAL)
        connectionCalback?(nil)
        connectionCalback = nil
        heartbeat?()
    }
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        receivedData.append(data)
        let range = readRawVarint32(data: &receivedData)
        if range.length > 0 && (range.location+range.length <= receivedData.length) {
            let cmdData = receivedData.subdata(with: range)
            callback?(cmdData, nil)
        }
        sock.readData(withTimeout: -1, tag: kGENERAL)
    }
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        debugPrint("tcp server断开:\(err?.localizedDescription)")
        /// 是否主动退出
        guard whetherInitiativeLogout == false else {
            debugPrint("initive logout")
            return
        }
        
        guard retryCounts < KRetryMaxCount else {
            debugPrint("重连达到上限!")
            clearTimer()
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(retry), object: nil)
            var e: BaseError?
            if let error = err {
                e = BaseError(error.localizedDescription)
            }
            connectionCalback?(e)
            return
        }
        clearTimer()
        let after = (retryCounts + 1) * 2 //幂等
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(after), execute:{
            self.retry()
        })
        retryCounts += 1
    }
    @objc private func retry() {
        if (serverIndex + 1) > servers.count {
            serverIndex = 0
        }
        let s = servers[serverIndex]
        let host = s["host"] as! String
        let port = s["port"] as! UInt16
        do {
            try socket.connect(toHost: host, onPort: port)
        } catch {
            debugPrint("failed on retry-connect: \(error.localizedDescription)")
        }
    }
}
