//
//  LogManager.swift
//  Log4s
//
//  Created by sagesse on 2018/5/10.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


open class LogManager {
    
    private init() {
        // By default we use a DefaultRepositorySelector which always returns 'hierarchy'.
        hierarchy = Hierarchy(root: RootLogger(level: .debug))
        
        // Configures the repository from environmental settings and files.
        DefaultConfigurator.load(hierarchy)
    }
    
    open var hierarchy: LoggerRepository

    
    open static let shared: LogManager = .init()
}
