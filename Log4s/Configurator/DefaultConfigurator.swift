//
//  DefaultConfigurator.swift
//  Log4s
//
//  Created by sagesse on 2018/5/11.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// Configures the repository from environmental settings and files.
///
internal class DefaultConfigurator {
    
    /// Interpret a resource pointed by a input data and set up log4j accordingly.
    internal static func load(_ hierarchy: LoggerRepository) {
        // Whether check environmental settings specifies a custom configurator class.
        let uclazz = System.property(for: "LOG4S_CONFIGURATOR_CLASS") ?? System.property(for: "log4j.configuratorClass")
        
        // if the user has not specified the log4j.configuration property,
        // we search first for the file "log4j.xml" and then "log4j.properties"
        let upath = System.property(for: "LOG4S_CONFIGURATION") ?? System.property(for: "log4j.configuration") ?? _default()
        
        // If we have a non-null url, then rest configuration with specified configurator class.
        guard let path = upath, let url = _resource(path) else {
            LogLog.debug("Could not find resource: [\(upath ?? "<NULL>")].")
            return
        }
        LogLog.debug("Using URL [\(url)] for automatic log4j configuration.")

        // If the user does not specify a custom configurator class, it is automatically recognized based on the file extension.
        guard let clazz = uclazz else {
            // If this value is null then a default configurator of
            // PropertyConfigurator is used, unless the filename pointed to by
            // url ends in '.xml', in which case XMLConfigurator is used.
            if url.pathExtension.lowercased() == "xml" {
                XMLConfigurator.load(contentsOf: url, hierarchy: hierarchy)
            } else {
                PropertyConfigurator.load(contentsOf: url, hierarchy: hierarchy)
            }
            return
        }
        
        // Load custom configurator class with name. this must be a subclass of Configurator.
        guard let type = Loader.class(clazz) as? Configurator.Type else {
            LogLog.error("Could not instantiate configurator [\(clazz)].")
            return
        }
        LogLog.debug("Preferred configurator class: \(clazz)")

        // Load configuration file
        type.load(contentsOf: url, hierarchy: hierarchy)
    }
    
    /// Using the resource file name to get the full path of the resource
    private static func _resource(_ path: String) -> URL? {
        guard !path.isEmpty else {
            return nil
        }
        
        let fm = FileManager.default
        let bundle = Bundle(for: self)
        
        // Check whether path is an absolute file URL.
        if let url = URL(string: path), url.scheme != nil {
            return url
        }
        
        // Check whether path is an absolute file path.
        if fm.fileExists(atPath: path) {
            return URL(fileURLWithPath: path)
        }

        // Check whether the configuration file is in the installation package.
        if let rpath = bundle.path(forResource: path, ofType: nil), fm.fileExists(atPath: rpath) {
            return URL(fileURLWithPath: rpath)
        }
        
        // Check whether the configuration file is in the installation package(in case for dynamic framework).
        if let rpath = Bundle.main.path(forResource: path, ofType: nil), fm.fileExists(atPath: rpath) {
            return URL(fileURLWithPath: rpath)
        }
        
        // Check whether the configuration file is in the Document(in case for iOS).
        for rpath in NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) {
            if fm.fileExists(atPath: rpath + "/" + path) {
                return URL(fileURLWithPath: rpath + "/" + path)
            }
        }
        
        // Check whether the configuration file is in the Library(in case for iOS).
        for rpath in NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) {
            if fm.fileExists(atPath: rpath + "/" + path) {
                return URL(fileURLWithPath: rpath + "/" + path)
            }
        }

        return nil
    }

    /// Get the default configuration file
    private static func _default() -> String? {
        let names = ["log4s.xml","log4s.properties","log4j.xml","log4j.properties"]
        for name in names {
            if let path = _resource(name) {
                return path.absoluteString
            }
        }

        return nil
    }
    
    
    
}
