//
//  Appender.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// Implement this interface for your own strategies for outputting log statements.
///
public protocol Appender: class {
    
    /// The name is used by other components to identify this appender.
    var name: String { set get }
    
    /// The appenders layout.
    var layout: Layout? { set get }
    
    /// The {@link ErrorHandler} for this appender.
    var errorHandler: ErrorHandler? { set get }
    
    
    /// Log in <code>Appender</code> specific way. When appropriate, Loggers will call the <code>append</code> method of appender implementations in order to log.
    func append(_ event: LoggingEvent)
    
    /// Release any resources allocated within the appender such as file handles, network connections, etc.
    func close()

    
    /// Returns the head Filter. The Filters are organized in a linked list and so all Filters on this Appender are available through the result.
    var filter: Filter? { get }
    
    /// Add a filter to the end of the filter list.
    func addFilter(_ filter: Filter)
    
    /// Clear the list of filters by removing all the filters in it.
    func clearFilters()

    
    /// Configurators call this method to determine if the appender requires a layout. If this method returns <code>true</code>, meaning that layout is required, then the configurator will configure an layout using the configuration information at its disposal.  If this method returns <code>false</code>, meaning that a layout is not required, then layout configuration will be skipped even if there is available layout configuration information at the disposal of the configurator..
    ///
    /// In the rather exceptional case, where the appender implementation admits a layout but can also work without it, then the appender should return <code>true</code>.
    var requiresLayout: Bool { get }
}

