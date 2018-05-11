//
//  PropertyConfigurator.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Cocoa

//public class PropertyConfigurator {
//    
//    public init(contentsOf url: URL)  {
//        // load file
//        do {
//            let properties = try Properties(contentsOf: url)
//            
//            self.configure(forRoot: properties, in: 1)
//        } catch (_) {
//            print("Could not read configuration file [\(url)].")
//            //LogLog::error(((LogString) LOG4CXX_STR("Could not read configuration file ["))
//            //+ configFileName.getPath() + LOG4CXX_STR("]."));
//            
//            //LogLog::error(((LogString) LOG4CXX_STR("Could not parse configuration file ["))
//            //+ configFileName.getPath() + LOG4CXX_STR("]."), ex);
//        }
//        
////        hierarchy->setConfigured(true);
////
////        Properties props;
////        try {
////        InputStreamPtr inputStream = new FileInputStream(configFileName);
////        props.load(inputStream);
////        } catch(const IOException& ie) {
////        LogLog::error(((LogString) LOG4CXX_STR("Could not read configuration file ["))
////        + configFileName.getPath() + LOG4CXX_STR("]."));
////        return;
////        }
////
////        try {
////        doConfigure(props, hierarchy);
////        } catch(const std::exception& ex) {
////        LogLog::error(((LogString) LOG4CXX_STR("Could not parse configuration file ["))
////        + configFileName.getPath() + LOG4CXX_STR("]."), ex);
////        }
//
//    }
//    
//    func configure(forRoot properties: Properties, in hierarchy: Any)  {
//        
//        let debug = properties["log4j.debug"]
//        if !debug.isEmpty {
//            // loglog.debugging = debug.sw_boolean ?? true
//        }
//
//        let threshold = properties["log4j.threshold"].sw_subst(in: properties)
//        if !threshold.isEmpty {
//            // hierarchy.threshold = threshold.sw_level ?? .all
//            // print("Hierarchy threshold set to [\(hierarchy.threshold)].")
//            let lv = threshold.sw_level ?? .all
//            print("Hierarchy threshold set to [\(lv)].")
//        }
//        
//        configure(forLogger: properties, in: hierarchy)
//        configure(forFactory: properties, in: hierarchy)
//
//    }
//    
//    func configure(forLogger properties: Properties, in hierarchy: Any) {
//        
//        var name = properties["log4j.rootLogger"].sw_subst(in: properties)
//        
//        if name.isEmpty {
//            name = properties["log4j.rootCategory"].sw_subst(in: properties)
//        }
//        
//        if name.isEmpty {
//            print("Could not find root logger information. Is this OK?")
//            return
//        }
//
//        //        LoggerPtr root = hierarchy->getRootLogger();
//        //
//        //        synchronized sync(root->getMutex());
//        //        static const LogString INTERNAL_ROOT_NAME(LOG4CXX_STR("root"));
//        //        parseLogger(props, root, effectiveFrefix, INTERNAL_ROOT_NAME, value);
////        prase(forLogger: properties, logger: value)
//    }
//    
//    func configure(forFactory properties: Properties, in hierarchy: Any) {
//        
//    }
//
//    
//    // This method must work for the root logger as well.
//    func prase(forLogger properties: Properties, key: String, name: String) {
//    }
//    func prase(forAppender properties: Properties, key: String) {
//    }
//}
