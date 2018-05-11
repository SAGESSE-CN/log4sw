//
//  NOPLoggerRepository.swift
//  Log4s
//
//  Created by sagesse on 2018/5/10.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// No-operation implementation of LoggerRepository which is used when LogManager.repositorySelector is erroneously nulled during class reloading.
///
public class NOPLoggerRepository: LoggerRepository {
    
    
    /// All logging requests below the threshold are immediately dropped.
    public var threshold: Level = .off
    
    
    /// Returns root logger for this repository
    public var root: Logger {
        return NOPLogger(name: "root", in: self)
    }
    
    /// Returns all logger for this repository
    public var loggers: [Logger] {
        return []
    }
    
    /// Returns logger of a specified name for this repository
    public func logger(_ name: String) -> Logger {
        return NOPLogger(name: name, in: self)
    }
    
    /// Returns logger of a specified name for this repository
    public func logger(_ name: String, factory: LoggerFactory) -> Logger {
        return NOPLogger(name: name, in: self)
    }
    
    
    /// Check if the named logger exists in the hierarchy.
    public func exists(_ name: String) -> Logger? {
        return nil
    }

    
    /// Reset all values contained in this hierarchy instance to their default.
    public func reset() {
    }
    
    /// Shutting down a hierarchy will <em>safely</em> close and remove all appenders in all categories including the root logger.
    public func shutdown() {
    }

    /// Report warning message into this repository
    public func warning(forNoAppender logger: Logger) {
    }
    
    
    /// Add hierarchy observer
    public func addHierarchyObserver(_ observer: Any) {
    }
    
    /// Remove hierarchy observer
    public func removeHierarchyObserver(_ observer: Any) {
    }
}
