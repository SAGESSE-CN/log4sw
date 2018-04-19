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
//        Pool p;
//        char* toto;
//        apr_status_t stat = apr_env_get(&toto, "TOTO",
//                                        p.getAPRPool());
//        LOGUNIT_ASSERT_EQUAL(APR_SUCCESS, stat);
//        LOGUNIT_ASSERT_EQUAL("wonderful", toto);
//        char* key1;
//        stat = apr_env_get(&key1, "key1",
//                           p.getAPRPool());
//        LOGUNIT_ASSERT_EQUAL(APR_SUCCESS, stat);
//        LOGUNIT_ASSERT_EQUAL("value1", key1);
//        char* key2;
//        stat = apr_env_get(&key2, "key2",
//                           p.getAPRPool());
//        LOGUNIT_ASSERT_EQUAL(APR_SUCCESS, stat);
//        LOGUNIT_ASSERT_EQUAL("value2", key2);
        
    }
    
    func testVarSubst1() {
        envCheck()
        
        let r1 = OptionConverter.substVars("hello world.", in: properties)
        XCTAssertEqual(r1, "hello world.")
        
        let r2 = OptionConverter.substVars("hello ${TOTO} world.", in: properties)
        XCTAssertEqual(r2, "hello wonderful world.")
    }
//
//
//    void varSubstTest2()
//    {
//    envCheck();
//    LogString r(OptionConverter::substVars(LOG4CXX_STR("Test2 ${key1} mid ${key2} end."),
//    nullProperties));
//    LOGUNIT_ASSERT_EQUAL((LogString) LOG4CXX_STR("Test2 value1 mid value2 end."), r);
//    }
//
//
//    void varSubstTest3()
//    {
//    envCheck();
//    LogString r(OptionConverter::substVars(
//    LOG4CXX_STR("Test3 ${unset} mid ${key1} end."), nullProperties));
//    LOGUNIT_ASSERT_EQUAL((LogString) LOG4CXX_STR("Test3  mid value1 end."), r);
//    }
//
//
//    void varSubstTest4()
//    {
//    LogString res;
//    LogString val(LOG4CXX_STR("Test4 ${incomplete "));
//    try
//{
//    res = OptionConverter::substVars(val, nullProperties);
//    }
//    catch(IllegalArgumentException& e)
//    {
//    std::string witness("\"Test4 ${incomplete \" has no closing brace. Opening brace at position 6.");
//    LOGUNIT_ASSERT_EQUAL(witness, (std::string) e.what());
//    }
//    }
//
//
//    void varSubstTest5()
//    {
//    Properties props1;
//    props1.setProperty(LOG4CXX_STR("p1"), LOG4CXX_STR("x1"));
//    props1.setProperty(LOG4CXX_STR("p2"), LOG4CXX_STR("${p1}"));
//    LogString res = OptionConverter::substVars(LOG4CXX_STR("${p2}"), props1);
//    LOGUNIT_ASSERT_EQUAL((LogString) LOG4CXX_STR("x1"), res);
//    }
//
//    void testTmpDir()
//    {
//    LogString actual(OptionConverter::substVars(
//    LOG4CXX_STR("${java.io.tmpdir}"), nullProperties));
//    Pool p;
//    const char* tmpdir = NULL;
//    apr_status_t stat = apr_temp_dir_get(&tmpdir, p.getAPRPool());
//    LOGUNIT_ASSERT_EQUAL(APR_SUCCESS, stat);
//    LogString expected;
//    Transcoder::decode(tmpdir, expected);
//
//    LOGUNIT_ASSERT_EQUAL(expected, actual);
//    }
//
//    #if APR_HAS_USER
//    void testUserHome() {
//    LogString actual(OptionConverter::substVars(
//    LOG4CXX_STR("${user.home}"), nullProperties));
//    Pool p;
//
//    apr_uid_t userid;
//    apr_gid_t groupid;
//    apr_status_t stat = apr_uid_current(&userid, &groupid, p.getAPRPool());
//    if (stat == APR_SUCCESS) {
//    char* username = NULL;
//    stat = apr_uid_name_get(&username, userid, p.getAPRPool());
//    if (stat == APR_SUCCESS) {
//    char* dirname = NULL;
//    stat = apr_uid_homepath_get(&dirname, username, p.getAPRPool());
//    if (stat == APR_SUCCESS) {
//    LogString expected;
//    Transcoder::decode(dirname, expected);
//    LOGUNIT_ASSERT_EQUAL(expected, actual);
//    }
//    }
//    }
//
//    }
//
//    void testUserName() {
//    LogString actual(OptionConverter::substVars(
//    LOG4CXX_STR("${user.name}"), nullProperties));
//    Pool p;
//    apr_uid_t userid;
//    apr_gid_t groupid;
//    apr_status_t stat = apr_uid_current(&userid, &groupid, p.getAPRPool());
//    if (stat == APR_SUCCESS) {
//    char* username = NULL;
//    stat = apr_uid_name_get(&username, userid, p.getAPRPool());
//    if (stat == APR_SUCCESS) {
//    LogString expected;
//    Transcoder::decode(username, expected);
//    LOGUNIT_ASSERT_EQUAL(expected, actual);
//    }
//    }
//    }
//    #endif
//
//    void testUserDir() {
//    LogString actual(OptionConverter::substVars(
//    LOG4CXX_STR("${user.dir}"), nullProperties));
//    Pool p;
//
//    char* dirname = NULL;
//    apr_status_t stat = apr_filepath_get(&dirname, APR_FILEPATH_NATIVE, p.getAPRPool());
//    LOGUNIT_ASSERT_EQUAL(APR_SUCCESS, stat);
//
//    LogString expected;
//    Transcoder::decode(dirname, expected);
//
//    LOGUNIT_ASSERT_EQUAL(expected, actual);
//    }
}
