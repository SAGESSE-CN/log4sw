//
//  PropertiesTests.swift
//  log4swTests
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import XCTest
@testable import log4sw

class PropertiesTests: XCTestCase {
    func testLoad1() {
        let properties = try? Properties(contentsOf: Resources("input/patternLayout1.properties"))
        
        XCTAssertNotNil(properties)
        XCTAssertEqual(properties?["log4j.appender.testAppender.layout.ConversionPattern"], "%-5p - %m%n")
    }
}
