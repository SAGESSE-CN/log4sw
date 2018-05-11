//
//  OptionConverter.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

/// A convenience class to convert property values to specific types.
public struct OptionConverter {
    /// OptionConverter is a static class.
    private init() {
    }
    
    ///
    /// Very similar to <code>System.getProperty</code> except that the {@link SecurityException} is hidden.
    ///
    /// - parameter key: The key to search for.
    /// - returns: the string value of the system property, or the null value if there is no property with that key.
    ///
    public static func getSystemProperty(_ key: String) -> String? {
        return System.property(for: key)
    }
    
    ///
    /// Perform variable substitution in string <code>val</code> from the values of keys found in the system propeties.
    ///
    /// The variable substitution delimeters are <b>${</b> and <b>}</b>.
    ///
    /// For example, if the System properties contains "key=value", then the call
    /// ```swift
    /// let s = OptionConverter.substVars("Value of key is ${key}.")
    /// ```
    /// will set the variable <code>s</code> to "Value of key is value.".
    ///
    /// If no value could be found for the specified key, then the <code>props</code> parameter is searched, if the value could not be found there, then substitution defaults to the empty string.
    ///
    ///
    /// For example, if system propeties contains no value for the key "inexistentKey", then the call
    ///
    /// ```swift
    /// let s = OptionConverter.subsVars("Value of inexistentKey is [${inexistentKey}]")
    /// ```
    /// will set <code>s</code> to "Value of inexistentKey is []"
    ///
    /// - parameter val: The string on which variable substitution is performed.
    ///
    public static func substVars(_ val: String, in props: Properties) -> String {
        
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
                print("\"\(self)\" has no closing brace. Opening brace at position \(begin.lowerBound.encodedOffset).")
                return ""
            }
            
            // copy non variable string
            sbuf.append(String(val[pos ..< begin.lowerBound]))
            pos = end.upperBound
            
            let key = String(val[begin.upperBound ..< end.lowerBound])
            guard !key.isEmpty else {
                continue
            }
            
            // first try in System properties
            var replacement = OptionConverter.getSystemProperty(key) ?? ""
            
            // then try props parameter
            if replacement.isEmpty {
                replacement = props[key] ?? ""
            }
            
            guard !replacement.isEmpty else {
                continue
            }
            
            // Do variable substitution on the replacement string
            // such that we can solve "Hello ${x2}" as "Hello p1"
            // the where the properties are
            // x1=p1
            // x2=${x1}
            sbuf.append(substVars(replacement, in: props))
        }
    }
    
    ///
    /// Find the value corresponding to <code>key</code> in <code>props</code>. Then perform variable substitution on the found value.
    ///
    public static func findAndSubst(_ key: String, in props: Properties) -> String? {
        
        guard let value = props[key] else {
            return nil
        }
        
        return substVars(value, in:props)
    }
    
    public static func convertSpecialChars(_ val: String) -> String {
        
        var sbuf = val
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
                
            case "n": ch = "\n"
            case "r": ch = "\r"
            case "t": ch = "\t"

            default: break
            }
            
            sbuf.replaceSubrange(pos ..< end, with: String(ch))
            pos = sbuf.index(after: pos)
        }
        
        return sbuf
    }
    
    /// If <code>value</code> is "true", then <code>true</code> is returned. If <code>value</code> is "false", then <code>true</code> is returned. Otherwise, <code>default</code> is returned.
    public static func toBoolean(_ val: String) -> Bool? {
        return Bool(val.lowercased())
    }
    
    public static func toFileSize<T>(_ val: String) -> T? where T : FixedWidthInteger {
        guard let unit = val.range(of: "b", options: .caseInsensitive), unit.lowerBound > val.startIndex else {
            // this is a simple number
            return T(val)
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
        
        return T(val[val.startIndex ..< pos]).map {
            return $0 * T(multiplier)
        }
    }
    
    public static func toInt<T>(_ val: String) -> T? where T : FixedWidthInteger {
        return T(val)
    }

    ///
    /// Converts a standard or custom priority level to a Level object.
    ///
    /// If <code>value</code> is of form "level#classname", then the specified class' toLevel method is called to process the specified level string; if no '#' character is present, then the default {@link org.apache.log4j.Level} class is used to process the level value.
    ///
    /// As a special case, if the <code>value</code> parameter is equal to the string "NULL", then the value <code>null</code> will be returned.
    ///
    /// If any error occurs while converting the value to a level, the <code>defaultValue</code> parameter, which may be <code>null</code>, is returned.
    ///
    /// Case of <code>value</code> is insignificant for the level level, but is significant for the class name part, if present.
    ///
    public static func toLevel(_ val: String) -> Level? {
        guard !val.isEmpty && val.compare("null", options: .caseInsensitive) != .orderedSame else {
            // the string special null
            return nil
        }
        
        guard let delimiter = val.range(of: "#") else {
            // no class name specified : use standard Level class
            return Level.level(for: val)
        }
        
        let name = String(val[val.startIndex ..< delimiter.lowerBound])
        let clazz = String(val[delimiter.upperBound ..< val.endIndex])
        
        print("OptionConverter::toLevel: class=[\(clazz)], pri=[\(name)]")
        
        // This is degenerate case but you never know.
        guard !name.isEmpty && name.compare("null", options: .caseInsensitive) != .orderedSame else {
            // the string special null
            return nil
        }
        
        do {
            
            return try (Loader.loadClass(clazz) as Level.Type).level(for: name)
            
        } catch {
            // ...
            // catch(ClassNotFoundException e) {
            //   LogLog.warn("custom level class [" + clazz + "] not found.");
            // catch(NoSuchMethodException e) {
            //   LogLog.warn("custom level class [" + clazz + "]"
            //       + " does not have a class function toLevel(String, Level)", e);
            // catch(java.lang.reflect.InvocationTargetException e) {
            //   if (e.getTargetException() instanceof InterruptedException
            //       || e.getTargetException() instanceof InterruptedIOException) {
            //       Thread.currentThread().interrupt();
            //   }
            //   LogLog.warn("custom level class [" + clazz + "]"
            //       + " could not be instantiated", e);
            // catch(ClassCastException e) {
            //   LogLog.warn("class [" + clazz
            //       + "] is not a subclass of org.apache.log4j.Level", e);
            // catch(IllegalAccessException e) {
            //   LogLog.warn("class ["+clazz+
            //       "] cannot be instantiated due to access restrictions", e);
            // catch(RuntimeException e) {
            //   LogLog.warn("class ["+clazz+"], level ["+levelName+
            //       "] conversion failed.", e);
            //
            
            return Level.level(for: val)
        }
    }
    
    
   
    ///
    /// Instantiate an object given a class name. Check that the <code>className</code> is a subclass of <code>superClass</code>. If that test fails or the object could not be instantiated, then <code>defaultValue</code> is returned.
    ///
    /// - parameter className: The fully qualified class name of the object to instantiate.
    /// - parameter superClass: The class to which the new object should belong.
    ///
    public static func instantiateByClassName<T>(_ className: String) -> T? {
        guard !className.isEmpty else {
            // the string is empty
            return nil
        }
        
        do {
            let type = (try Loader.loadClass(className) as T.Type)
            fatalError()
            //    LogLog.error("A \""+className+"\" object is not assignable to a \""+
            //    superClass.getName() + "\" variable.");
            //    LogLog.error("The class \""+ superClass.getName()+"\" was loaded by ");
            //    LogLog.error("["+superClass.getClassLoader()+"] whereas object of type ");
            //    LogLog.error("\"" +classObj.getName()+"\" was loaded by ["
            //    +classObj.getClassLoader()+"].");

            
        } catch {
            fatalError()

        }
        //    Object instantiateByClassName(String className, Class superClass,
        //    Object defaultValue) {
        //    if(className != null) {
        //    try {
        //    Class classObj = Loader.loadClass(className);
        //    if(!superClass.isAssignableFrom(classObj)) {
        //    LogLog.error("A \""+className+"\" object is not assignable to a \""+
        //    superClass.getName() + "\" variable.");
        //    LogLog.error("The class \""+ superClass.getName()+"\" was loaded by ");
        //    LogLog.error("["+superClass.getClassLoader()+"] whereas object of type ");
        //    LogLog.error("\"" +classObj.getName()+"\" was loaded by ["
        //    +classObj.getClassLoader()+"].");
        //    return defaultValue;
        //    }
        //    return classObj.newInstance();
        //    } catch (ClassNotFoundException e) {
        //    LogLog.error("Could not instantiate class [" + className + "].", e);
        //    } catch (IllegalAccessException e) {
        //    LogLog.error("Could not instantiate class [" + className + "].", e);
        //    } catch (InstantiationException e) {
        //    LogLog.error("Could not instantiate class [" + className + "].", e);
        //    } catch (RuntimeException e) {
        //    LogLog.error("Could not instantiate class [" + className + "].", e);
        //    }
        //    }
        //    return defaultValue;
        //    }

    }

}

internal extension String {
    internal func log4s_equals<T>(_ str: T) -> Bool where T : StringProtocol {
        return compare(str, options: .caseInsensitive) != .orderedSame
    }
    internal func log4s_prefix(_ str: String) -> String? {
        guard hasPrefix(str) else {
            return nil
        }
        return String(self[self.index(startIndex, offsetBy: str.count)...])
    }
}


