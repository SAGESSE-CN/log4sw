//
//  Appender.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// This class provides the code for common functionality, such as
/// support for threshold filtering and support for general filters.
///
public class Appender: OptionKeyValueCoding {
    
    //    /// The name uniquely identifies the appender.
//    var name: String { set get }
//    
//    /// The Layout for this appender.
//    var layout: Layout { set get }
//    
//    
//    /// Returns the head Filter. The Filters are organized in a linked list
//    /// and so all Filters on this Appender are available through the result.
//    ///
//    /// - returns: the head Filter or null, if no Filters are present
//    func filter() -> Filter?
//    
//    /// Add a filter to the end of the filter list.
//    func addFilter(_ filter: Filter)
//    
//    /// Clear the list of filters by removing all the filters in it.
//    func clearFilters()
//    
//    
//    /// Release any resources allocated within the appender such as file
//    /// handles, network connections, etc.
//    /// <p>It is a programming error to append to a closed appender.
//    func close()
//    
//
//    /// Configurators call this method to determine if the appender
//    /// requires a layout. If this method returns <code>true</code>,
//    /// meaning that layout is required, then the configurator will
//    /// configure an layout using the configuration information at its
//    /// disposal.  If this method returns <code>false</code>, meaning that
//    /// a layout is not required, then layout configuration will be
//    /// skipped even if there is available layout configuration
//    /// information at the disposal of the configurator..
//    ///
//    /// <p>In the rather exceptional case, where the appender
//    /// implementation admits a layout but can also work without it, then
//    /// the appender should return <code>true</code>.
//    var requiresLayout: Bool { get }
    
    var threshold: Level = .all

    /// Sets the property of the receiver specified by a given key to a given value.
    public func setValue(_ value: String, forKey key: String) {
        switch key {
        case let key where key.sw_equal("threshold"):
            threshold = Level.level(for: value) ?? .all

        default:
            // nothing
            break
        }
    }
    
    /// Sets the value for the property identified by a given key path to a given value.
    public func setValue(_ value: String, forKeyPath keyPath: String) {
        // Nothing
    }
    
    
    /// Activate the options that were previously set with calls to option setters.
    public func activate() {
        // Nothing
    }
    
    private var _head: Filter?
    private var _tail: Filter?
    
    private var _closed: Bool = false
}

