//
//  NOPLogger.swift
//  Log4s
//
//  Created by sagesse on 2018/5/10.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// No-operation implementation of Logger used by NOPLoggerRepository.
///
public class NOPLogger: Logger {
    
    ///
    /// Create instance of Logger.
    ///
    /// - parameter name: name, may not be null, use "root" for root logger.
    /// - parameter repository: repository, may not be null.
    ///
    internal init(name: String, in repository: NOPLoggerRepository) {
        super.init(name: name)
    }
    
    ///
    /// No-operation do not output any logs
    ///
    public override func enabled(for level: Level) -> Bool {
        return false
    }
}
