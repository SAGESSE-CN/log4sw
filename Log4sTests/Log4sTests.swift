//
//  log4swTests.swift
//  log4swTests
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

func Resources(_ path: String) -> URL {
    class ResourcesOfBundle {}
    return Bundle(for: ResourcesOfBundle.self).resourceURL!.appendingPathComponent("resources/\(path)")
}

