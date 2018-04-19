//
//  OptionConverterTests.swift
//  log4swTests
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import XCTest
@testable import log4sw

class OptionConverterTests: XCTestCase {
    
    var properties = Properties()

    /**
     * Checks that environment variables were properly set
     * before invoking tests.  ::putenv not reliable.
     */
    func envCheck() {
        XCTAssertEqual(try? System.env(for: "key1"), "value1")
        XCTAssertEqual(try? System.env(for: "key2"), "value2")
        
        XCTAssertEqual(try? System.env(for: "TOTO"), "wonderful")
    }
    
    func testVarSubst1() {
        envCheck()
        
        XCTAssertEqual(try? OptionConverter.substVars("hello world.", in: properties), "hello world.")
        XCTAssertEqual(try? OptionConverter.substVars("hello ${TOTO} world.", in: properties), "hello wonderful world.")
    }

    func testVarSubst2() {
        envCheck()
        
        XCTAssertEqual(try? OptionConverter.substVars("Test2 ${key1} mid ${key2} end.", in: properties), "Test2 value1 mid value2 end.")
    }

    func testVarSubst3() {
        envCheck()
        
        XCTAssertEqual(try? OptionConverter.substVars("Test3 ${unset} mid ${key1} end.", in: properties), "Test3  mid value1 end.")
    }

    func testVarSubst4() {
        do {
            _ = try OptionConverter.substVars("Test4 ${incomplete ", in: properties)
            
            // If the execution is here, the exception is not thrown out
            XCTFail("Unknown exception")
        } catch let e as IllegalArgumentException {
            XCTAssertEqual(e.message, "\"Test4 ${incomplete \" has no closing brace. Opening brace at position 6.")
        } catch {
            XCTFail("Unknown exception")
        }
    }
  
    func testVarSubst5() {
        let properties = Properties()
        
        properties["p1"] = "x1"
        properties["p2"] = "${p1}"
        
        XCTAssertEqual(try? OptionConverter.substVars("${p2}", in: properties), "x1")
    }

    func testTmpDir() {
        XCTAssertEqual(try? OptionConverter.substVars("${java.io.tmpdir}", in: properties), NSTemporaryDirectory())
    }

    func testUserDir() {
        XCTAssertEqual(try? OptionConverter.substVars("${user.dir}", in: properties), try? System.env(for: "user.dir"))
    }
}
