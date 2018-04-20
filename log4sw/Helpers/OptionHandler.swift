//
//  OptionHandler.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


public protocol OptionKeyValueCoding {
    
    /// Sets the property of the receiver specified by a given key to a given value.
    func setValue(_ value: String, forKey key: String)
    
    /// Activate the options that were previously set with calls to option setters.
    func activate()
}
