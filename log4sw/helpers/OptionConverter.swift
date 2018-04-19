//
//  OptionConverter.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

class OptionConverter: NSObject {

//    func find
    
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
    static func substVars(_ val: String, in properties: Properties) -> String {
        
        
        return val
    }
}
