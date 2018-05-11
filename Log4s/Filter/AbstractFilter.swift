//
//  AbstractFilter.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

typealias Setter = (Any, String) -> ()

func setter<S, T>(_ keyPath: ReferenceWritableKeyPath<S, T>) -> Setter {
    return {
        ($0 as! S)[keyPath: keyPath] = $1 as! T
    }
}

///
/// Users should extend this class to implement filters. Filters can be either context wide or attached to
/// an appender. A filter may choose to support being called only from the context or only from an appender in
/// which case it will only implement the required method(s). The rest will default to return [neutral](file:///Users/sagesse/Projects/log4sw/log4sw/Filter/Filter.swift).
///
public class AbstractFilter: Filter {

    public var onMatch: FilterResult = .neutral
    public var onMismatch: FilterResult = .deny
    
    static var onMatch: Setter = setter(\AbstractFilter.onMatch)
    
    /// Context Filter method.
    public func filter(_ event: Any) -> FilterResult {
        return .neutral
    }

    /// Sets the property of the receiver specified by a given key to a given value.
    public func setValue(_ value: String, forKey key: String) {
        
    }
    
    /// Activate the options that were previously set with calls to option setters.
    public func activate() {
    }

//    static var d: [KeyPath<AbstractFilter, FilterResult>] = [
//        \AbstractFilter.onMatch,
//        \AbstractFilter.onMismatch
//    ]
}
