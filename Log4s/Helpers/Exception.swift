//
//  Exception.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


enum Exception: Error {
    case classNotFound
    case noSuchMethod
    case classCast
}

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


struct IllegalArgumentException: Error {
    init(_ message: String) {
        self.message = message
    }
    let message: String
}
