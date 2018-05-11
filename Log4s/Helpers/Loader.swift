//
//  Loader.swift
//  Log4s
//
//  Created by sagesse on 2018/5/8.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


public protocol Loadable: class {
    
    ///
    /// The fully qualified name of the class.
    ///
    static var FQCN: String { get }
}

public class Loader {
    
    public static func `register`(_ clazz: Loadable.Type) {
        _registry[clazz.FQCN] = clazz
    }
    
    public static func `class`(_ name: String) -> AnyClass? {
        
        guard let clazz = _registry[name] else {
            return nil
        }
        
        print(clazz)
        fatalError()
    }

    
    public static func loadClass<T>(_ name: String) throws -> T.Type {
        fatalError()
    }
    
    public static func newInstance<T>(_ name: String) throws -> T {
        fatalError()
    }
//    /**
//     * If running under JDK 1.2 load the specified class using the
//     *  <code>Thread</code> <code>contextClassLoader</code> if that
//     *  fails try Class.forname. Under JDK 1.1 only Class.forName is
//     *  used.
//     *
//     */
//    static public Class loadClass (String clazz) throws ClassNotFoundException {
//    // Just call Class.forName(clazz) if we are running under JDK 1.1
//    // or if we are instructed to ignore the TCL.
//    if(java1 || ignoreTCL) {
//    return Class.forName(clazz);
//    } else {
//    try {
//    return getTCL().loadClass(clazz);
//    }
//    // we reached here because tcl was null or because of a
//    // security exception, or because clazz could not be loaded...
//    // In any case we now try one more time
//    catch(InvocationTargetException e) {
//    if (e.getTargetException() instanceof InterruptedException
//    || e.getTargetException() instanceof InterruptedIOException) {
//    Thread.currentThread().interrupt();
//    }
//    } catch(Throwable t) {
//    }
//    }
//    return Class.forName(clazz);
//    }
    
    
    /// Load all support Loadable the class.
    private static func _load() -> Dictionary<String, Loadable.Type> {
        var count = UInt32(0)
        var result = Dictionary<String, Loadable.Type>()
        
        // The built-in class must be forced to load once
        _ = [
            XMLConfigurator.self,
            PropertyConfigurator.self,
            
            FileAppender.self,
            RollingFileAppender.self,
        ]
        
        if let types = objc_copyClassList(&count) {
            for index in 0 ..< Int(count) {
                // Filter all types of no support Loadable
                guard let clazz = types[index] as? Loadable.Type else {
                    continue
                }
                result[clazz.FQCN] = clazz
            }
        }
        
        return result
    }
    
    private static var _registry: Dictionary<String, Loadable.Type> = Loader._load()
}
