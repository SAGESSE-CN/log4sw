//
//  LoggerRepository.swift
//  Log4s
//
//  Created by sagesse on 2018/5/8.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// A <code>LoggerRepository</code> is used to create and retrieve <code>Loggers</code>. The relation between loggers in a repository depends on the repository but typically loggers are arranged in a named hierarchy.
///
/// <p>In addition to the creational methods, a <code>LoggerRepository</code> can be queried for existing loggers, can act as a point of registry for events related to loggers.
///
public protocol LoggerRepository: class {
    
    ///
    /// All logging requests below the threshold are immediately dropped.
    /// By default, the threshold is set to <code>Level.ALL</code> which has the lowest possible rank.
    ///
    var threshold: Level { set get }
    
    
    ///
    /// Returns root logger for this repository
    ///
    var root: Logger { get }

    ///
    /// Returns all logger for this repository
    ///
    var loggers: [Logger] { get }
    
    
    ///
    /// Returns logger of a specified name for this repository
    ///
    /// - parameter name: The specified logger name
    ///
    func logger(_ name: String) -> Logger
    
    ///
    /// Return a new logger instance named as the first parameter using **factory**.
    ///
    /// If a logger of that name already exists, then it will be returned.  Otherwise, a new logger will be instantiated by the <code>factory</code> parameter and linked with its existing ancestors as well as children.
    ///
    /// - parameter name: The name of the logger to retrieve.
    /// - parameter factory: The factory that will make the new logger instance.
    ///
    func logger(_ name: String, factory: LoggerFactory) -> Logger
    
    
    ///
    /// Check if the named logger exists in the hierarchy.
    /// If so return its reference, otherwise returns **nil**.
    ///
    /// - parameter name: The name of the logger to search for.
    ///
    func exists(_ name: String) -> Logger?
    
    
    ///
    /// Reset all values contained in this hierarchy instance to their default.
    ///
    func reset()
    
    ///
    /// Shutting down a hierarchy will <em>safely</em> close and remove all appenders in all categories including the root logger.
    ///
    func shutdown()
    
    ///
    /// Report warning message into this repository
    ///
    func warning(forNoAppender logger: Logger)
    
    
    ///
    /// Add hierarchy observer
    ///
    func addHierarchyObserver(_ observer: Any)
    
    ///
    /// Remove hierarchy observer
    ///
    func removeHierarchyObserver(_ observer: Any)
}
