//
//  OptionHandler.swift
//  log4sw
//
//  Created by sagesse on 2018/4/20.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


public protocol OptionHandler {
    
    func option(forKey key: String) -> Any?
    func option(forKeyPath keyPath: String) -> Any?
    
    func setOption(_ value: String, forKey key: String)
    func setOption(_ value: String, forKeyPath keyPath: String)
}
