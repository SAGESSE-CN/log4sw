//
//  Filter.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// The result that can returned from a filter method call.
///
public enum FilterResult: Int {
    
    /// The event should not be processed.
    case deny = -1
    
    /// No decision could be made, further filtering should occur.
    case neutral = 0
    
    /// The event will be processed without further filtering based on the log Level.
    case accept = 1
    
    /// Returns the Result for the given string.
    public init?(_ name: String) {
        switch name.lowercased() {
        case "deny":
            self = .deny

        case "neutral":
            self = .neutral

        case "accept":
            self = .accept

        default:
            return nil
        }
    }
}

///
/// Interface that must be implemented to allow custom event filtering. It is highly recommended that
/// applications make use of the Filters provided with this implementation before creating their own.
///
/// This interface supports "global" filters (i.e. - all events must pass through them first), attached to
/// specific loggers and associated with Appenders. It is recommended that, where possible, Filter implementations
/// create a generic filtering method that can be called from any of the filter methods.
///
public protocol Filter: OptionKeyValueCoding {
    
    /// Returns the result that should be returned when the filter matches the event.
    var onMatch: FilterResult { get }

    /// Returns the result that should be returned when the filter does not match the event.
    var onMismatch: FilterResult { get }

    /// Context Filter method.
    /// - parameter event: The LogEvent.
    /// - returns: The Result of filtering.
    func filter(_ event: Any) -> FilterResult
}
