//
//  PropertyConfigurator.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Cocoa

public class PropertyConfigurator {
    
    public init(contentsOf url: URL)  {
        // load file
        do {
            let properties = try Properties(contentsOf: url)
            
            self.prase(properties)
        } catch (_) {
            //LogLog::error(((LogString) LOG4CXX_STR("Could not read configuration file ["))
            //+ configFileName.getPath() + LOG4CXX_STR("]."));
            
            //LogLog::error(((LogString) LOG4CXX_STR("Could not parse configuration file ["))
            //+ configFileName.getPath() + LOG4CXX_STR("]."), ex);
        }
        
//        hierarchy->setConfigured(true);
//
//        Properties props;
//        try {
//        InputStreamPtr inputStream = new FileInputStream(configFileName);
//        props.load(inputStream);
//        } catch(const IOException& ie) {
//        LogLog::error(((LogString) LOG4CXX_STR("Could not read configuration file ["))
//        + configFileName.getPath() + LOG4CXX_STR("]."));
//        return;
//        }
//
//        try {
//        doConfigure(props, hierarchy);
//        } catch(const std::exception& ex) {
//        LogLog::error(((LogString) LOG4CXX_STR("Could not parse configuration file ["))
//        + configFileName.getPath() + LOG4CXX_STR("]."), ex);
//        }

    }
    
    func prase(_ properties: Properties) {
        
        
        
    }

}
