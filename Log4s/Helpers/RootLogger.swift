//
//  RootLogger.swift
//  Log4s
//
//  Created by sagesse on 2018/5/10.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// RootLogger sits at the top of the logger hierachy. It is a regular logger except that it provides several guarantees.
///
/// First, it cannot be assigned a <code>null</code> level. Second, since root logger cannot have a parent, the {@link #getChainedLevel} method always returns the value of the level field without walking the hierarchy.
///
public class RootLogger: Logger {
    
    ///
    /// The root logger names itself as "root". However, the root logger cannot be retrieved by name.
    ///
    public init(level: Level) {
        super.init(name: "root")
        self.level = level
    }
    
    /// Setting a null value to the level of the root logger may have catastrophic results. We prevent this here.
    public override var level: Level? {
        set {
            guard let level = newValue else {
                LogLog.error("You have tried to set a null level to root.")
                return
            }
            return super.level = level
        }
        get {
            return super.level
        }
    }

}
