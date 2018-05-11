//
//  AppenderAttachable.swift
//  Log4s
//
//  Created by sagesse on 2018/5/8.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// Interface for attaching appenders to objects.
///
public protocol AppenderAttachable: class {
    
    /// Add an appender.
    func appendAppender(_ appender: Appender)
    
    
    /// Remove the appender passed as parameter from the list of appenders.
    func removeAppender(_ appender: Appender)

    /// Remove the appender with the name passed as parameter from the list of appenders.
    func removeAppender(forName name: String)

    /// Remove all previously added appenders.
    func removeAllAppenders()

    
    /// Get all previously added appenders as an Enumeration.  */
    var appenders: Array<Appender> { get }
    
    /// Get an appender by name.
    func appender(forName name: String) -> Appender?
    
    
    /// Returns <code>true</code> if the specified appender is in list of attached attached, <code>false</code> otherwise.
    func hasAppender(_ element: Appender) -> Bool
}
