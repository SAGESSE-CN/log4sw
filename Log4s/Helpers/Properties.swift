//
//  Properties.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

public class Properties {
    fileprivate struct Parser {
        fileprivate enum LexemType: Int {
            case begin
            case key
            case key_escape
            case key_continue
            case key_continue2
            case delimiter
            case element
            case element_escape
            case element_continue
            case element_continue2
            case comment
        }
        
        /// Reference: log4cxx/src/main/cpp/properties.cpp
        fileprivate static func parse(_ contents: String) -> Dictionary<String, String> {
            
            var result = Dictionary<String, String>()
            var type = LexemType.begin
            var pos = contents.startIndex
            
            var key = ""
            var element = ""
            
            while pos != contents.endIndex {
                let ch = contents[pos]
                switch type {
                case .begin:
                    switch ch {
                    case " ","\t","\n","\r":
                        // is blank section
                        type = .begin
                        pos = contents.index(after: pos)
                        
                    case "#","!":
                        // is comment section
                        type = .comment
                        pos = contents.index(after: pos)
                        
                    default:
                        // is key section
                        type = .key
                    }
                case .key:
                    switch ch {
                    case "\\":
                        type = .key_escape
                        pos = contents.index(after: pos)
                        
                    case " ","\t",":","=":
                        type = .delimiter
                        pos = contents.index(after: pos)
                        
                    case "\r","\n":
                        // key associated with an empty string element
                        result[key.lowercased()] = element
                        key.removeAll()
                        type = .begin
                        pos = contents.index(after: pos)
                        
                    default:
                        // is key contents
                        key.append(ch)
                        pos = contents.index(after: pos)
                    }
                case .key_escape:
                    switch ch {
                    case " ","\t",":","=","\\":
                        key.append(ch)
                        type = .key
                        pos = contents.index(after: pos)
                        
                    case "\r":
                        type = .key_continue2
                        pos = contents.index(after: pos)
                        
                    case "\n":
                        type = .key_continue
                        pos = contents.index(after: pos)
                        
                    default:
                        break
                    }
                case .key_continue:
                    switch ch {
                    case " ","\t":
                        // is blank
                        pos = contents.index(after: pos)
                        
                    default:
                        type = .key
                    }
                case .key_continue2:
                    switch ch {
                    case "\n":
                        type = .key_continue
                        pos = contents.index(after: pos)
                        
                    default:
                        type = .key_continue
                    }
                case .delimiter:
                    switch ch {
                    case " ","\t",":","=":
                        // is blank
                        pos = contents.index(after: pos)
                        
                    default:
                        type = .element
                    }
                case .element:
                    switch ch {
                    case "\\":
                        type = .element_escape
                        pos = contents.index(after: pos)
                        
                    case "\r","\n":
                        // key associated with an empty string element
                        result[key.lowercased()] = element
                        key.removeAll()
                        element.removeAll()
                        type = .begin
                        pos = contents.index(after: pos)
                        
                    default:
                        // is element contents
                        element.append(ch)
                        pos = contents.index(after: pos)
                    }
                case .element_escape:
                    switch ch {
                    case "\n":
                        type = .element_continue
                        pos = contents.index(after: pos)
                        
                    case "\r":
                        type = .element_continue2
                        pos = contents.index(after: pos)
                        
                    default:
                        // is element contents
                        element.append(ch)
                        pos = contents.index(after: pos)
                    }
                case .element_continue:
                    switch ch {
                    case " ","\t":
                        // is blank
                        pos = contents.index(after: pos)
                        
                    default:
                        type = .element
                    }
                case .element_continue2:
                    switch ch {
                    case "\n":
                        // is blank line
                        type = .element_continue
                        pos = contents.index(after: pos)
                        
                    default:
                        type = .element_continue
                    }
                case .comment:
                    switch ch {
                    case "\r","\n":
                        // comment content is end
                        type = .begin
                        pos = contents.index(after: pos)
                        
                    default:
                        // ignore
                        pos = contents.index(after: pos)
                    }
                }
            }
            
            if !key.isEmpty {
                result[key.lowercased()] = element
            }
            
            return result
        }
    }
    
    ///
    /// A empty properties for tests
    ///
    internal init() {
        _properties = [:]
    }
    
    ///
    /// Reads a property list (key and element pairs) from the input stream.
    /// The stream is assumed to be using the ISO 8859-1 character encoding.
    ///
    /// Every property occupies one line of the input stream.
    /// Each line is terminated by a line terminator (**\\n** or **\\r** or **\\r\\n**).
    /// Lines from the input stream are processed until end of file is reached on the input stream.
    ///
    /// A line that contains only whitespace or whose first non-whitespace character is an ASCII **#** or **!**
    /// is ignored (thus, **#** or **!** indicate comment lines).
    ///
    /// Every line other than a blank line or a comment line describes one property to be added to the table (except
    /// that if a line ends with **\**, then the following line, if it exists, is treated as a continuation line, as
    /// described below). The key consists of all the characters in the line starting with the first non-whitespace
    /// character and up to, but   not including, the first ASCII **=**, **:**, or whitespace character. All of the key
    /// termination characters may be included in the key by preceding them with a **\\**. Any whitespace after the key
    /// is skipped;
    /// if the first non-whitespace character after the key is **=** or **:**, then it is ignored and any whitespace
    /// characters after it are also skipped. All remaining characters on the line become part of the associated
    /// element string.
    /// Within the element string, the ASCII sw_escape sequences **\\t**, **\\n**, **\\r**, **\\**, **\\"**, **\\'**,
    /// **\\ **a backslash and a space), and **\\uxxxx** are recognized and converted to single characters. Moreover,
    /// if the last character on the line is **\\**, then the next line is treated as a continuation of the pos line;
    /// the **\\** and line terminator are simply discarded, and any leading whitespace characters on the continuation
    /// line are also discarded and are not part of the element string.
    ///
    /// As an example, each of the following four lines specifies the key "Truth" and the associated element value
    /// "Beauty":
    ///
    /// ```
    /// Truth = Beauty
    /// Truth:Beauty
    /// Truth         :Beauty
    /// ```
    ///
    /// As another example, the following three lines specify a single
    /// property:
    /// ```
    /// fruits           apple, banana, pear, \
    /// cantaloupe, watermelon, \
    /// kiwi, mango
    /// ```
    /// The key is "**fruits**" and the associated element is:
    /// ```
    /// "apple, banana, pear, cantaloupe, watermelon, kiwi, mango"
    /// ```
    /// Note that a space appears before each \ so that a space will appear after each comma in the final result;
    /// the \, line terminator, and leading whitespace on the continuation line are merely discarded and are not
    /// replaced by one or more other characters.
    ///
    /// As a third example, the line:
    /// ```
    /// cheeses
    /// ```
    /// specifies that the key is "**cheeses**" and the associated
    /// element is the empty string.
    ///
    internal init(contents: String) {
        _properties = Parser.parse(contents)
    }
    
    ///
    /// Returns an enumeration of all the keys in this property list, including distinct keys in the default property
    /// list if a key of the same name has not already been found from the main properties list.
    ///
    internal var names: Array<String> {
        return Array(_properties.keys)
    }
    
    ///
    /// Puts a property value into the collection.
    /// Gets a property value.
    ///
    internal subscript(key: String) -> String? {
        set { return _properties[key.lowercased()] = newValue }
        get { return _properties[key.lowercased()] }
    }
    
    func names(for prefix: String) -> Array<String> {
        return names.filter {
            return $0.hasPrefix(prefix)
        }
    }
    
    
    fileprivate var _properties: Dictionary<String, String> = [:]
}

internal extension Properties {
    
    /// Get the original string data
    func decode<T>(_ value: T.Type, forKey key: String) -> T? where T : StringProtocol {
        guard let str = self[key] else {
            return nil
        }

        return OptionConverter.substVars(str, in: self) as? T
    }

    /// If the T support LosslessStringConvertible protocol, use it directly
    func decode<T>(_ value: T.Type, forKey key: String) -> T? where T : LosslessStringConvertible {
        // First converts into a string
        guard let str = decode(String.self, forKey: key) else {
            return nil
        }
        return T(str)
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
    func decode(_ value: Level.Type, forKey key: String) -> Level? {
        LogLog.debug("Parsing level for \"\(key)\".")
        
        // First converts into a string
        guard let str = decode(String.self, forKey: key) else {
            return nil
        }
        
        // The string special null
        guard !str.isEmpty && !str.log4s_equals("null") else {
            return nil
        }
        
        // A custom level value can be specified in the form level#classname
        guard let delimiter = str.range(of: "#") else {
            // No class name specified : use standard Level class
            return Level.level(for: str)
        }
        
        let name = String(str[str.startIndex ..< delimiter.lowerBound])
        let clazz = String(str[delimiter.upperBound ..< str.endIndex])
        
        // The string special null
        guard !name.isEmpty && !name.log4s_equals("null") else {
            return nil
        }
        
        LogLog.debug("Parsing level for custom class=[\(clazz)], pri=[\(name)]")
        
        do {
            
            let type = try Loader.loadClass(clazz) as Level.Type
            
            return type.level(for: name)
            
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
        }
        
        return nil
    }
    
    func decode(_ value: Level.Names.Type, forKey key: String) -> Level.Names? {
        LogLog.debug("Parsing level name for \"\(key)\".")
        
        // We must skip over ',' but not white space
        guard let names = decode(String.self, forKey: key)?.components(separatedBy: ",") else {
            return nil
        }
        
        // If value is not in the form ", appender.." or "", then we should set the level of the logger.
        return (Level.level(for: names.first ?? ""), names.suffix(from: 1).compactMap {
            // The blank character must be remove
            let name = $0.trimmingCharacters(in: .whitespaces)
            
            // Ignore blank appender name
            guard !name.isEmpty else {
                return nil
            }
            
            return name
        })
    }
    
    
    func decode(_ value: Appender.Protocol, forKey key: String) -> Appender? {
        LogLog.debug("Parsing appender for \"\(key)\".")
        
        // Get the value of the property in string form
        // Trim className to avoid trailing spaces that cause problems.
        guard let clazz = decode(String.self, forKey: key)?.trimmingCharacters(in: .whitespaces), !clazz.isEmpty else {
            LogLog.error("Could not find value for key " + key)
            return nil
        }
        
        guard let appenderType = Loader.class(clazz) as? Appender.Type else {
            return nil
        }
        
        guard let appender = OptionConverter.instantiateByClassName(clazz) as Appender? else {
            LogLog.error("Could not instantiate appender for \"\(key)\".")
            return nil
        }
        
        if appender.requiresLayout {
            
            //            Layout layout = (Layout) OptionConverter.instantiateByKey(props,
            //                                                                      layoutPrefix,
            //                                                                      Layout.class,
            //                                                                      null);
            //            if(layout != null) {
            //                appender.setLayout(layout);
            //                LogLog.debug("Parsing layout options for \"" + appenderName +"\".");
            //                //configureOptionHandler(layout, layoutPrefix + ".", props);
            //                PropertySetter.setProperties(layout, props, layoutPrefix + ".");
            //                LogLog.debug("End of parsing for \"" + appenderName +"\".");
            //            }
            
            appender.layout = nil
        }
        
        
        
        
        //        do {
        //            try Loader.loadClass(clazz) as Appender.Type
        //
        //        } catch {
        //
        //        }
        
        //        guard let appender = decode(Appender.self, forKey: key) else {
        //            return nil
        //        }
        
        return nil
    }
    
    func decode(_ value: LoggerFactory.Type, forKey key: String) -> LoggerFactory? {
        LogLog.debug("Parsing logger factory for \"\(key)\".")
        
        // Get the value of the property in string form
        // Trim className to avoid trailing spaces that cause problems.
        guard let clazz = decode(String.self, forKey: key)?.trimmingCharacters(in: .whitespaces), !clazz.isEmpty else {
            return nil
        }
        
        //            LogLog.debug("Setting category factory to ["+factoryClassName+"].");
        //            loggerFactory = (LoggerFactory)
        //            OptionConverter.instantiateByClassName(factoryClassName,
        //                                                   LoggerFactory.class,
        //                                                   loggerFactory);
        //            PropertySetter.setProperties(loggerFactory, props, FACTORY_PREFIX + ".");
        
//        "log4j.factory"
        
        return nil
    }
    
    
    
    //    func decode<T>(_ value: T.Type, forKey key: String) -> T? where T : Any {
    //        LogLog.debug("Parsing appender for \"\(key)\".")
    //        return nil
    //    }
    
    
    
    //    /**
    //     Used internally to keep track of configured appenders.
    //     */
    //    private LoggerRepository repository;
    //    protected LoggerFactory loggerFactory = new DefaultCategoryFactory();
    //
    //    static final String       FACTORY_PREFIX = "log4j.factory";
    //    static final String      RENDERER_PREFIX = "log4j.renderer.";
    //    private static final String      THROWABLE_RENDERER_PREFIX = "log4j.throwableRenderer";
    //    private static final String LOGGER_REF    = "logger-ref";
    //    private static final String ROOT_REF        = "root-ref";
    //    private static final String APPENDER_REF_TAG     = "appender-ref";
    //

}

