//
//  Exception.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


struct IllegalArgumentException: Error {
    init(_ message: String) {
        self.message = message
    }
    let message: String
}
