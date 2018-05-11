//
//  LogLog.swift
//  Log4s
//
//  Created by sagesse on 2018/5/8.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// This class used to output log statements from within the log4j package.
///
/// Log4j components cannot make log4j logging calls. However, it is sometimes useful for the user to learn about what log4j is doing.
///
/// All log4j internal debug calls go to <code>System.out</code> where as internal error messages are sent to <code>System.err</code>. All internal messages are prepended with the string "log4j: ".
///
public class LogLog {
    
    /// Allows to enable/disable log4j internal logging.
    public static var debugging = OptionConverter.toBoolean(OptionConverter.getSystemProperty("log4j.debug") ?? "") ?? false
    
    /// In quietMode not even errors generate any output.
    public static var quiet = false

    
    /// This method is used to output log4j internal debug statements. Output goes to <code>System.out</code>.
    public static func debug(_ msg: String) {
        guard !quiet && debugging else {
            return
        }
        print("log4j: \(msg)")
    }
    
   /// This method is used to output log4j internal warning statements. There is no way to disable warning statements. Output goes to <code>System.err</code>.
    public static func warn(_ msg: String) {
        guard !quiet else {
            return
        }
        print("log4j:WARN \(msg)")
    }

    /// This method is used to output log4j internal error statements. There is no way to disable error statements. Output goes to <code>System.err</code>.
    public static func error(_ msg: String) {
        guard !quiet else {
            return
        }
        print("log4j:ERROR \(msg)")
    }
}
