//
//  Logger.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// This is the central class in the log4j package. Most logging operations, except configuration, are done through this class.
///
open class Logger: AppenderAttachable {
    
    /// The name of this logger.
    open var name: String
    
    /// The assigned level of this logger.  The <code>level</code> variable need not be assigned a value in which case it is inherited form the hierarchy.
    open var level: Level?
    
    
    /// The parent of this logger. All loggers have at least one ancestor which is the root logger.
    open weak var parent: Logger?
    
    /// Loggers need to know what Hierarchy they are in
    open weak var hierarchy: LoggerRepository?
    
    
    /// Additivity is set to true by default, that is children inherit the appenders of their ancestors by default. If this variable is set to <code>false</code> then the appenders found in the ancestors of this category are not used. However, the children of this category will inherit its appenders, unless the children have their additivity flag set to <code>false</code> too. See the user manual for more details.
    open var additivity: Bool = true
    

    ///
    /// Starting from this category, search the logger hierarchy for a non-null level and return it. Otherwise, return the level of the root logger.
    ///
    /// The Logger class is designed so that this method executes as quickly as possible.
    ///
    open var effectiveLevel: Level? {
        return level ?? parent?.effectiveLevel
    }
    
    ///
    /// Check whether this logger is enabled for a given Level passed as parameter.
    ///
    open func enabled(for level: Level) -> Bool {
        return false
    }

    
    // MARK: -
    
    
    ///
    /// Add **appender** to the list of appenders of this Logger instance.
    ///
    /// If **appender** is already in the list of appenders, then it won't be added again.
    ///
    open func appendAppender(_ appender: Appender) {
        guard !hasAppender(appender) else {
            return
        }
        return _appenders.append(appender)
    }
    
    ///
    /// Remove the appender passed as parameter from the list of appenders.
    ///
    open func removeAppender(_ appender: Appender) {
        return _appenders = _appenders.filter {
            return $0.name.log4s_equals(name)
        }
    }
    
    ///
    /// Remove the appender with the name passed as parameter from the list of appenders.
    ///
    open func removeAppender(forName name: String) {
        return _appenders = _appenders.filter {
            return $0.name.log4s_equals(name)
        }
    }
    
    ///
    /// Remove all previously added appenders from this Logger instance.
    ///
    /// This is useful when re-reading configuration information.
    ///
    open func removeAllAppenders() {
        return _appenders = []
    }
    
    ///
    /// Get the appenders contained in this category as an Array. If no appenders can be found, then a NullArray is returned.
    ///
    /// - returns: Array of the appenders in this logger.
    ///
    open var appenders: Array<Appender> {
        return _appenders
    }
    
    ///
    /// Look for the appender named as <code>name</code>.
    ///
    /// Return the appender with that name if in the list. Return <code>null</code> otherwise.
    ///
    open func appender(forName name: String) -> Appender? {
        return _appenders.first {
            return $0.name.log4s_equals(name)
        }
    }
    
    ///
    /// Returns <code>true</code> if the specified appender is in list of attached attached, <code>false</code> otherwise.
    ///
    open func hasAppender(_ element: Appender) -> Bool {
        return _appenders.contains {
            return $0.name.log4s_equals(name)
        }
    }
    
    ///
    /// Close all attached appenders implementing the AppenderAttachable interface.
    ///
    open func closeNestedAppenders() {
        return _appenders.forEach {
            $0.close()
        }
    }
    
    
    // MARK: -
    

    ///
    /// This constructor created a new <code>Logger</code> instance and sets its name.
    ///
    /// It is intended to be used by sub-classes only. You should not create logger directly.
    ///
    /// - parameter name: The name of the logger.
    ///
    internal init(name: String) {
        self.name = name
    }

    
    private var _appenders: [Appender] = []
}

public extension Logger {
    
    ///
    /// Return the root logger for the current logger repository.
    ///
    /// The **Logger.name** method for the root logger always returns string value: "root". However, calling **Logger.logger("root")** does not retrieve the root logger but a logger just under root named "root".
    ///
    /// In other words, calling this method is the only way to retrieve the root logger.
    ///
    public static var rootLogger: Logger {
        fatalError()
    }
    
    ///
    /// Retrieve a logger named according to the value of the <code>name</code> parameter. If the named logger already exists, then the existing instance will be returned. Otherwise, a new instance is created.
    ///
    /// By default, loggers do not have a set level but inherit it from their neareast ancestor with a set level. This is one of the central features of log4j.
    ///
    /// - parameter name: The name of the logger to retrieve.
    ///
    public static func logger(_ name: String) -> Logger {
        fatalError()
    }
    
    ///
    /// Shorthand for <code>getLogger(clazz.getName())</code>.
    ///
    /// - parameter clazz: The name of **clazz** will be used as the name of the logger to retrieve.
    ///
    public static func logger(_ clazz: AnyClass) -> Logger {
        fatalError()
    }

    
    // MARK: -
    
    
    /// Log a message object with the **TRACE** level.
    public var trace: LoggerRef? {
        // if **TRACE** has been disabled, ignore it
        guard enabled(for: .trace) else {
            return nil
        }
        return .init(level: .trace, logger: self)
    }
    
    /// Log a message object with the **DEBUG** level.
    public var debug: LoggerRef? {
        // if **DEBUG** has been disabled, ignore it
        guard enabled(for: .debug) else {
            return nil
        }
        return .init(level: .debug, logger: self)
    }
    
    /// Log a message object with the **INFO** level.
    public var info: LoggerRef? {
        // if **INFO** has been disabled, ignore it
        guard enabled(for: .info) else {
            return nil
        }
        return .init(level: .info, logger: self)
    }
    
    /// Log a message object with the **WARN** level.
    public var warn: LoggerRef? {
        // if **WARN** has been disabled, ignore it
        guard enabled(for: .warn) else {
            return nil
        }
        return .init(level: .warn, logger: self)
    }
    
    /// Log a message object with the **ERROR** level.
    public var error: LoggerRef? {
        // if **ERROR** has been disabled, ignore it
        guard enabled(for: .error) else {
            return nil
        }
        return .init(level: .error, logger: self)
    }
    
    /// Log a message object with the **FATAL** level.
    public var fatal: LoggerRef? {
        // if **FATAL** has been disabled, ignore it
        guard enabled(for: .fatal) else {
            return nil
        }
        return .init(level: .fatal, logger: self)
    }
}

public struct LoggerRef {
    
    internal init(level: Level, logger: Logger) {
        _level = level
        _logger = logger
    }
    
    // This is the most generic printing method.
    public func write(_ items: Any..., method: String = #function, file: String = #file, line: Int = #line) {
        // ..
        
        
        // emit a message to logger
        _emit(0 as! LoggingEvent)
    }
    
    /// Call the `append` method on all attached appenders.
    private func _emit(_ event: LoggingEvent) {
        
        var count = 0
        var logger = _logger
        
        while true  {
            // Write to all attached appenders
            for appender in logger.appenders {
                appender.append(event)
                count += 1
            }
            
            // Write to parent logger
            guard let parent = logger.parent, logger.additivity else {
                break
            }
            
            logger = parent
        }
        
        guard count == 0 else {
            return
        }
        
        // if no appenders could be found, emit a warning.
        logger.hierarchy?.warning(forNoAppender: logger)
    }
    
    private let _level: Level
    private let _logger: Logger
}

