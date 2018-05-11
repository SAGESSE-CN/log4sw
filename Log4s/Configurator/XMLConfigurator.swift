//
//  XMLConfigurator.swift
//  Log4s
//
//  Created by sagesse on 2018/5/11.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


open class XMLConfigurator: Configurator, Loadable {
    
    
    public required init?(contentsOf url: URL) {
    }
    
    open func apply(_ hierarchy: LoggerRepository) {
    }
    
    /// The fully qualified name of the class.
    open class var FQCN: String {
        return "org.apache.log4j.xml.DOMConfigurator"
    }
}
