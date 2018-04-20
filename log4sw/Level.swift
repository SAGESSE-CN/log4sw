//
//  Level.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


/**
 * Levels used for identifying the severity of an event. Levels are organized from most specific to least:
 * <ul>
 * <li>OFF (most specific, no logging)</li>
 * <li>FATAL (most specific, little data)</li>
 * <li>ERROR</li>
 * <li>WARN</li>
 * <li>INFO</li>
 * <li>DEBUG</li>
 * <li>TRACE (least specific, a lot of data)</li>
 * <li>ALL (least specific, all data)</li>
 * </ul>
 *
 * Typically, configuring a level in a filter or on a logger will cause logging events of that level and those that are
 * more specific to pass through the filter. A special level, {@link #ALL}, is guaranteed to capture all levels when
 * used in logging configurations.
 */
public class Level: Hashable, Equatable, Comparable, CustomStringConvertible {
    
    /// Create a new instance
    private init(level: Int, name: String) {
        self.name = name
        self.level = level
    }

    /// Gets the integral value of this Level.
    public let level: Int

    /// Gets the symbolic name of this Level. Equivalent to calling {@link #description}.
    public let name: String
    
    /// The level description
    public var description: String {
        return name
    }
    
    /// The level hash.
    public var hashValue: Int {
        return level
    }

    /// All events should be logged.
    public static var all = Level(level: Int.max, name: "ALL")
    
    /// No events will be logged.
    public static var off = Level(level: Int.min, name: "OFF")

    /// A severe error that will prevent the application from continuing.
    public static var fatal = Level(level: 60_0000, name: "FATAL")
    
    /// An error in the application, possibly recoverable.
    public static var error = Level(level: 50_0000, name: "ERROR")
    
    /// An event that might possible lead to an error.
    public static var warn = Level(level: 40_0000, name: "WARN")
    
    /// An event for informational purposes.
    public static var info = Level(level: 30_0000, name: "INFO")
    
    /// A general debugging event.
    public static var debug = Level(level: 20_0000, name: "DEBUG")
    
    /// A fine-grained debug message, typically capturing the flow through the application.
    public static var trace = Level(level: 10_0000, name: "TRACE")
    
    ///
    /// Retrieves an existing Level.
    ///
    /// - name: The name of the level.
    /// - returns: The Level.
    ///
    public static func level(for name: String) -> Level? {
        for level: Level in [.all, .fatal, .error, .warn, .info, .debug, .trace, .off] {
            guard level.description.sw_equal(name) else {
                continue
            }
            return level
        }
        return nil
    }
}

/// A type that can be compared for value equality.
public func == (lhs: Level, rhs: Level) -> Bool {
    return lhs.level == rhs.level
}

/// A type that can be compared using the relational operators <, <=, >=, and >.
public func < (lhs: Level, rhs: Level) -> Bool {
    return lhs.level < rhs.level
}
