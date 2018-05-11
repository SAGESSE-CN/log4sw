//
//  LoggerFactory.swift
//  Log4s
//
//  Created by sagesse on 2018/5/9.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// Implement this interface to create new instances of Logger or a sub-class of Logger.
///
/// See <code>examples/subclass/MyLogger.java</code> for an example.
///
open class LoggerFactory {
    
    open func logger(_ name: String) -> Logger {
        return Logger(name: name)
    }
}
