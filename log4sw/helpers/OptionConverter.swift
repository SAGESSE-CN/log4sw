//
//  OptionConverter.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

internal extension String {
    
    var sw_escape: String {
        
        var sbuf = self
        var pos = sbuf.startIndex
        
        while pos < sbuf.endIndex {
            
            var ch = sbuf[pos]
            var end = sbuf.index(after: pos)
            
            guard ch == "\\" else {
                // ignore
                pos = end
                continue
            }
            
            ch = sbuf[end]
            end = sbuf.index(after: end)
            
            switch ch {
            case "n":
                ch = "\n"
                
            case "r":
                ch = "\r"
                
            case "t":
                ch = "\t"
                
            default:
                break
            }
            
            sbuf.replaceSubrange(pos ..< end, with: String(ch))
            pos = sbuf.index(after: pos)
        }
        
        return sbuf
    }
    
    var sw_capacity: Int? {
        guard let unit = self.range(of: "b", options: .caseInsensitive), unit.lowerBound > self.startIndex else {
            // this is a simple number
            return Int(self)
        }
        
        var pos = self.index(before: unit.lowerBound)
        var multiplier = 1
        
        switch self[pos] {
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
        
        return Int(self[self.startIndex ..< pos]).map {
            return $0 * multiplier
        }
    }
    
    var sw_integer: Int? {
        return Int(self)
    }
    
    var sw_boolean: Bool? {
        return Bool(self.lowercased())
    }
    
    var sw_level: String? {
        return nil
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
    func sw_subst(in properties: Properties) -> String {
        
        var sbuf = ""
        var pos = self.startIndex
        
        while true {
            guard let begin = self.range(of: "${", range: pos ..< self.endIndex) else {
                // no more variables
                guard pos != self.startIndex else {
                    // this is a simple string
                    return self
                }
                
                // add the tail string which contails no variables and return the result.
                return sbuf + self[pos ..< self.endIndex]
            }
            
            guard let end = self.range(of: "}", range: begin.upperBound ..< self.endIndex) else {
                print("\"\(self)\" has no closing brace. Opening brace at position \(begin.lowerBound.encodedOffset).")
                return ""
            }
            
            // copy non variable string
            sbuf.append(String(self[pos ..< begin.lowerBound]))
            pos = end.upperBound
            
            let key = String(self[begin.upperBound ..< end.lowerBound])
            guard !key.isEmpty else {
                continue
            }
            
            // first try in System properties
            var replacement = System.env(for: key) ?? ""
            
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
            sbuf.append(replacement.sw_subst(in: properties))
        }
    }
}
