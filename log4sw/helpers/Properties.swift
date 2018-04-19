//
//  Properties.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

internal class Properties {
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
        fileprivate static func parse(_ contents: String, in properties: Properties) {
            
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
                        properties[key] = element
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
                        properties[key] = element
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
                properties[key] = element
            }
        }
    }
    
    internal init() {
        // nothing
    }
    internal init(contentsOf url: URL) throws {
        // load file
        try self.load(contentsOf: url)
    }
    
    ///
    /// Reads a property list (key and element pairs) from the input stream.
    /// The stream is assumed to be using the ISO 8859-1 character encoding.
    ///
    /// <p>Every property occupies one line of the input stream.
    /// Each line is terminated by a line terminator (<code>\\n</code> or
    /// <code>\\r</code> or <code>\\r\\n</code>).
    /// Lines from the input stream are processed until end of file is reached
    /// on the input stream.
    ///
    /// <p>A line that contains only whitespace or whose first non-whitespace
    /// character is an ASCII <code>#</code> or <code>!</code> is ignored
    /// (thus, <code>#</code> or <code>!</code> indicate comment lines).
    ///
    /// <p>Every line other than a blank line or a comment line describes one
    /// property to be added to the table (except that if a line ends with \,
    /// then the following line, if it exists, is treated as a continuation
    /// line, as described below). The key consists of all the characters in
    /// the line starting with the first non-whitespace character and up to,
    /// but   not including, the first ASCII <code>=</code>, <code>:</code>,
    /// or whitespace character. All of the
    /// key termination characters may be included in the key by preceding them
    /// with a <code>\\</code>. Any whitespace after the key is skipped;
    /// if the first
    /// non-whitespace character after the key is <code>=</code> or
    /// <code>:</code>, then it is ignored
    /// and any whitespace characters after it are also skipped. All remaining
    /// characters on the line become part of the associated element string.
    /// Within the element string, the ASCII sw_escape sequences <code>\\t</code>,
    /// <code>\\n</code>, <code>\\r</code>, <code>\\</code>, <code>\\"</code>,
    /// <code>\\'</code>, <code>\\</code> (a backslash and a space), and
    /// <code>\\uxxxx</code> are recognized
    /// and converted to single characters. Moreover, if the last character on
    /// the line is <code>\\</code>, then the next line is treated as a
    /// continuation of the
    /// pos line; the <code>\\</code> and line terminator are simply
    /// discarded, and any
    /// leading whitespace characters on the continuation line are also
    /// discarded and are not part of the element string.
    ///
    /// <p>As an example, each of the following four lines specifies the key
    /// "Truth" and the associated element value "Beauty":
    ///
    /// <pre>
    /// Truth = Beauty
    /// Truth:Beauty
    /// Truth         :Beauty
    /// </pre>
    ///
    /// As another example, the following three lines specify a single
    /// property:
    /// <pre>
    /// fruits           apple, banana, pear, \
    /// cantaloupe, watermelon, \
    /// kiwi, mango
    /// </pre>
    /// The key is "<code>fruits</code>" and the associated element is:
    /// <pre>
    /// "apple, banana, pear, cantaloupe, watermelon, kiwi, mango"
    /// </pre>
    /// Note that a space appears before each \ so that a space will appear
    /// after each comma in the final result; the \, line terminator, and
    /// leading whitespace on the continuation line are merely discarded and are
    /// not replaced by one or more other characters.
    ///
    /// <p>As a third example, the line:
    /// <pre>
    /// cheeses
    /// </pre>
    /// specifies that the key is "<code>cheeses</code>" and the associated
    /// element is the empty string.
    ///
    /// @param inStream the input stream.
    ///
    /// @throw IOException if an error occurred when reading from the input
    /// stream.
    ///
    internal func load(contentsOf url: URL) throws {
        // read whole file
        let contents = try String(contentsOf: url)
        
        Parser.parse(contents, in: self)
    }
    
    ///
    /// Returns an enumeration of all the keys in this property list,
    /// including distinct keys in the default property list if a key
    /// of the same name has not already been found from the main
    /// properties list.
    /// - Returns: an array of all the keys in this property list, including the keys in the default property list.
    ///
    internal var names: Array<String> {
        return Array(_properties.keys)
    }

    ///
    /// Puts a property value into the collection.
    /// Gets a property value.
    ///
    internal subscript(key: String) -> String {
        set { return _properties[key] = newValue }
        get { return _properties[key] ?? "" }
    }

    fileprivate var _properties: Dictionary<String, String> = [:]
}
