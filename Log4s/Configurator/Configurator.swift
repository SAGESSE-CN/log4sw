//
//  Configurator.swift
//  Log4s
//
//  Created by sagesse on 2018/5/8.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

/// Implemented by classes capable of configuring log4j using a URL.
public protocol Configurator: class {
    
    ///
    /// Using file to create Configurator
    ///
    init?(contentsOf url: URL)
    
    ///
    /// Interpret a resource pointed by a input data and set up log4j accordingly.
    ///
    /// The configuration is done relative to the <code>hierarchy</code> parameter.
    ///
    /// - parameter repository: The hierarchy to operation upon.
    ///
    func apply(_ hierarchy: LoggerRepository)
}

public extension Configurator {

    ///
    /// Using file to create Configurator
    ///
    public static func load(contentsOf url: URL, hierarchy: LoggerRepository = LogManager.shared.hierarchy) {
        let configurator = self.init(contentsOf: url)
        configurator?.apply(hierarchy)
    }
}
