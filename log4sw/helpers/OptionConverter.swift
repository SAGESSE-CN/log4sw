//
//  OptionConverter.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

class OptionConverter: NSObject {
    
    /**
     If <code>value</code> is "true", then <code>true</code> is
     returned. If <code>value</code> is "false", then
     <code>true</code> is returned. Otherwise, <code>default</code> is
     returned.
     
     <p>Case of value is unimportant.
     */
    
    static func capacity(_ val: String) -> Int? {
        guard let unit = val.range(of: "b", options: .caseInsensitive), unit.lowerBound > val.startIndex else {
            // this is a simple number
            return Int(val)
        }
        
        var pos = val.index(before: unit.lowerBound)
        var multiplier = 1
        
        switch val[pos] {
        case "k","K":
            multiplier = 1024
            
        case "m","M":
            multiplier = 1024 * 1024
            
        case "g","G":
            multiplier = 1024 * 1024 * 1024
            
        case "t","T":
            multiplier = 1024 * 1024 * 1024 * 1024
            
        case "p","P":
            multiplier = 1024 * 1024 * 1024 * 1024 * 1024
            
        default:
            pos = unit.lowerBound // no extended unit
        }
        
        return Int(val[val.startIndex ..< pos]).map {
            return $0 * multiplier
        }
    }
    
    static func integer(_ val: String) -> Int? {
        return Int(val)
    }
    
    static func boolean(_ val: String) -> Bool? {
        return Bool(val.lowercased())
    }
    
    static func level(_ val: String) {
    }
//    static LevelPtr toLevel(const LogString& value,
//    const LevelPtr& defaultValue);


    /**
     Find the value corresponding to <code>key</code> in
     <code>props</code>. Then perform variable substitution on the
     found value.
     */
    static func findAndSubst(_ key: String, in properties: Properties) -> String {
        let value = properties[key]
        guard !value.isEmpty else {
            return value
        }
        
        do {
            return try substVars(value, in: properties)
        } catch {
            print("Bad option value [\(value)].", error)
            return value
        }
    }

    /**
     Perform variable substitution in string <code>val</code> from the
     values of keys found in the system propeties.
     
     <p>The variable substitution delimeters are <b>${</b> and <b>}</b>.
     
     <p>For example, if the System properties contains "key=value", then
     the call
     <pre>
     String s = OptionConverter.substituteVars("Value of key is ${key}.");
     </pre>
     
     will set the variable <code>s</code> to "Value of key is value.".
     
     <p>If no value could be found for the specified key, then the
     <code>props</code> parameter is searched, if the value could not
     be found there, then substitution defaults to the empty string.
     
     <p>For example, if system propeties contains no value for the key
     "inexistentKey", then the call
     
     <pre>
     String s = OptionConverter.subsVars("Value of inexistentKey is [${inexistentKey}]");
     </pre>
     will set <code>s</code> to "Value of inexistentKey is []"
     
     <p>An IllegalArgumentException is thrown if
     <code>val</code> contains a start delimeter "${" which is not
     balanced by a stop delimeter "}". </p>
     
     @param val The string on which variable substitution is performed.
     @param props The properties from which variable substitution is performed.
     @throws IllegalArgumentException if <code>val</code> is malformed.
     */
    static func substVars(_ val: String, in properties: Properties) throws -> String {
        
        var sbuf = ""
        var pos = val.startIndex
        
        while true {
            guard let begin = val.range(of: "${", range: pos ..< val.endIndex) else {
                // no more variables
                guard pos != val.startIndex else {
                    // this is a simple string
                    return val
                }
                
                // add the tail string which contails no variables and return the result.
                return sbuf + val[pos ..< val.endIndex]
            }
            
            guard let end = val.range(of: "}", range: begin.upperBound ..< val.endIndex) else {
                throw IllegalArgumentException("\"\(val)\" has no closing brace. Opening brace at position \(begin.lowerBound.encodedOffset).")
            }
            
            // copy non variable string
            sbuf.append(String(val[pos ..< begin.lowerBound]))
            pos = end.upperBound
            
            let key = String(val[begin.upperBound ..< end.lowerBound])
            guard !key.isEmpty else {
                continue
            }
            
            // first try in System properties
            var replacement = try System.env(for: key) ?? ""
            
            // then try props parameter
            if replacement.isEmpty {
                replacement = properties[key]
            }
            
            guard !replacement.isEmpty else {
                continue
            }
            
            // Do variable substitution on the replacement string
            // such that we can solve "Hello ${x2}" as "Hello p1"
            // the where the properties are
            // x1=p1
            // x2=${x1}
            sbuf.append(try substVars(replacement, in: properties))
        }
    }
}
