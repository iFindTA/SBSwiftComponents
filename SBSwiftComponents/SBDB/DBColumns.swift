//
//  DBColumns.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/6.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import SQLite
import Foundation

public struct DBColumns {
    //public columns
    public static let tableID = Expression<Int>("id")//表ID
    public static let tableVersion = Expression<String>("tableVersion")//表版本
    public static let timestamp = Expression<TimeInterval>("timestamp")//时间戳
}
