//
//  Logger.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

/// This is the central class in the log4cxx package. Most logging
/// operations, except configuration, are done through this class.
public protocol Logger {
    
    /// The name uniquely identifies the logger.
    var name: String { get }
    
    /// The assigned level of this logger.  The
    /// [level](Level.swift) variable need not be assigned a value in
    /// which case it is inherited form the hierarchy.
    var level: Level { get }
    
    /// The parent of this logger. The root logger will return
    var parent: Logger? { get }
    
    /// The additivity flag for this Logger instance.
    var additivity: Bool { set get }


    
    /// Get the appenders contained in this logger as an AppenderList.
    /// If no appenders can be found, then an empty AppenderList
    /// is returned.
    func appenders() -> Array<Appender>

    /// Look for the appender named as **name**.
    /// <p>Return the appender with that name if in the list. Return
    /// <code>NULL</code> otherwise.
    func appender(_ name: String) -> Appender?
    
    /// Add <code>newAppender</code> to the list of appenders of this Logger instance.
    /// <p>If <code>newAppender</code> is already in the list of
    /// appenders, then it won't be added again.
    func addAppender(_ appender: Appender)
    
    /// Remove the appender passed as parameter form the list of appenders.
    func removeAppender(_ appender: Appender)
    
    /// Remove the appender with the name passed as parameter form the list of appenders.
    func removeAppender(_ name: String)
    
    /// Remove all previously added appenders from this logger instance.
    /// <p>This is useful when re-reading configuration information.
    func removeAllAppenders()
    
    /// Close all attached appenders implementing the AppenderAttachable interface.
    func closeNestedAppenders()
}

public extension Logger {
    
    /// Retrieve the root logger.
    public static var root: Logger {
        fatalError()
    }
    
    /// Retrieve a logger by name in current encoding.
    public static func logger(for name: String) -> Logger {
        fatalError()
    }
}

