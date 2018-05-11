//
//  PropertiesTests.swift
//  log4swTests
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import XCTest
@testable import Log4s

class PropertiesTests: XCTestCase {
    func testLoad1() {
        
        let contents = try! String(contentsOf: Resources("input/patternLayout1.properties"))
        let properties = Properties(contents: contents)
        
        XCTAssertNotEqual(properties.names.count, 0)
        XCTAssertEqual(properties["log4j.appender.testAppender.layout.ConversionPattern"], "%-5p - %m%n")
    }
}
