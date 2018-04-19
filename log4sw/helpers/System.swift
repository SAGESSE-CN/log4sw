//
//  System.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Cocoa

/**
 The System class contains several useful class fields and methods.
 It cannot be instantiated.
 */
struct System {
    
    /**
     Gets the system property indicated by the specified key.
     
     @param key the name of the system property.
     
     @return the string value of the system property, or the default value if
     there is no property with that key.
     
     @throws IllegalArgumentException if key is empty.
     */
    static func env(_ key: String) -> String? {
        return nil
//        if (lkey.empty())
//        {
//            throw IllegalArgumentException(LOG4CXX_STR("key is empty"));
//        }
//
//        LogString rv;
//        if (lkey == LOG4CXX_STR("java.io.tmpdir")) {
//            Pool p;
//            const char* dir = NULL;
//            apr_status_t stat = apr_temp_dir_get(&dir, p.getAPRPool());
//            if (stat == APR_SUCCESS) {
//                Transcoder::decode(dir, rv);
//            }
//            return rv;
//        }
//
//        if (lkey == LOG4CXX_STR("user.dir")) {
//            Pool p;
//            char* dir = NULL;
//            apr_status_t stat = apr_filepath_get(&dir, APR_FILEPATH_NATIVE,
//                                                 p.getAPRPool());
//            if (stat == APR_SUCCESS) {
//                Transcoder::decode(dir, rv);
//            }
//            return rv;
//        }
//        #if APR_HAS_USER
//        if (lkey == LOG4CXX_STR("user.home") || lkey == LOG4CXX_STR("user.name")) {
//            Pool pool;
//            apr_uid_t userid;
//            apr_gid_t groupid;
//            apr_pool_t* p = pool.getAPRPool();
//            apr_status_t stat = apr_uid_current(&userid, &groupid, p);
//            if (stat == APR_SUCCESS) {
//                char* username = NULL;
//                stat = apr_uid_name_get(&username, userid, p);
//                if (stat == APR_SUCCESS) {
//                    if (lkey == LOG4CXX_STR("user.name")) {
//                        Transcoder::decode(username, rv);
//                    } else {
//                        char* dirname = NULL;
//                        stat = apr_uid_homepath_get(&dirname, username, p);
//                        if (stat == APR_SUCCESS) {
//                            Transcoder::decode(dirname, rv);
//                        }
//                    }
//                }
//            }
//            return rv;
//        }
//        #endif
//
//        LOG4CXX_ENCODE_CHAR(key, lkey);
//        Pool p;
//        char* value = NULL;
//        apr_status_t stat = apr_env_get(&value, key.c_str(),
//                                        p.getAPRPool());
//        if (stat == APR_SUCCESS) {
//            Transcoder::decode((const char*) value, rv);
//        }
//        return rv;
    }
}
