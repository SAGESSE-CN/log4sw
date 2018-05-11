//
//  OptionConverterTests.swift
//  log4swTests
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import XCTest
@testable import Log4s

class OptionConverterTests: XCTestCase {
    
//    var properties = Properties()
//
//    /**
//     * Checks that environment variables were properly set
//     * before invoking tests.  ::putenv not reliable.
//     */
//    func envCheck() {
//        XCTAssertEqual(System.env(for: "key1"), "value1")
//        XCTAssertEqual(System.env(for: "key2"), "value2")
//
//        XCTAssertEqual(System.env(for: "TOTO"), "wonderful")
//    }
//
//    func testVarSubst1() {
//        envCheck()
//
//        XCTAssertEqual("hello world.".sw_subst(in: properties), "hello world.")
//        XCTAssertEqual("hello ${TOTO} world.".sw_subst(in: properties), "hello wonderful world.")
//    }
//
//    func testVarSubst2() {
//        envCheck()
//
//        XCTAssertEqual("Test2 ${key1} mid ${key2} end.".sw_subst(in: properties), "Test2 value1 mid value2 end.")
//    }
//
//    func testVarSubst3() {
//        envCheck()
//
//        XCTAssertEqual("Test3 ${unset} mid ${key1} end.".sw_subst(in: properties), "Test3  mid value1 end.")
//    }
//
//    func testVarSubst4() {
//        XCTAssertEqual("Test4 ${incomplete ".sw_subst(in: properties), "")
//    }
//
//    func testVarSubst5() {
//        let properties = Properties()
//
//        properties["p1"] = "x1"
//        properties["p2"] = "${p1}"
//
//        XCTAssertEqual("${p2}".sw_subst(in: properties), "x1")
//    }
//
//    func testTmpDir() {
//        XCTAssertEqual("${java.io.tmpdir}".sw_subst(in: properties), NSTemporaryDirectory())
//    }
//
//    func testUserName() {
//        XCTAssertEqual("${user.name}".sw_subst(in: properties), NSUserName())
//    }
//
//    func testUserHome() {
//        XCTAssertEqual("${user.home}".sw_subst(in: properties), NSHomeDirectory())
//    }
//
//    func testUserDir() {
//        XCTAssertEqual("${user.dir}".sw_subst(in: properties), System.env(for: "user.dir"))
//    }
//
//    func testEscape() {
//        XCTAssertEqual("-\\n-".sw_escape, "-\n-")
//        XCTAssertEqual("-\\n".sw_escape, "-\n")
//        XCTAssertEqual("\\n".sw_escape, "\n")
//        XCTAssertEqual("\\n\\r".sw_escape, "\n\r")
//
//        XCTAssertEqual("\\a".sw_escape, "a")
//        XCTAssertEqual("\\\\".sw_escape, "\\")
//    }
//
//    func testCapacity() {
//        XCTAssertEqual("2b".sw_capacity, 2)
//        XCTAssertEqual("22B".sw_capacity, 22)
//
//        XCTAssertEqual("2kb".sw_capacity, 2*1024)
//        XCTAssertEqual("2Kb".sw_capacity, 2*1024)
//        XCTAssertEqual("2mb".sw_capacity, 2*1024*1024)
//        XCTAssertEqual("2Mb".sw_capacity, 2*1024*1024)
//        XCTAssertEqual("2gb".sw_capacity, 2*1024*1024*1024)
//        XCTAssertEqual("2Gb".sw_capacity, 2*1024*1024*1024)
//        XCTAssertEqual("2tb".sw_capacity, 2*1024*1024*1024*1024)
//        XCTAssertEqual("2Tb".sw_capacity, 2*1024*1024*1024*1024)
//        XCTAssertEqual("2pb".sw_capacity, 2*1024*1024*1024*1024*1024)
//        XCTAssertEqual("2Pb".sw_capacity, 2*1024*1024*1024*1024*1024)
//    }
}
