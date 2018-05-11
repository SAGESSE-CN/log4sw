//
//  PropertyConfigurator.swift
//  Log4s
//
//  Created by sagesse on 2018/5/8.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation


///
/// Allows the configuration of log4j from an external file.  See **{@link #doConfigure(String, LoggerRepository)}** for the expected format.
///
/// It is sometimes useful to see how log4j is reading configuration files. You can enable log4j internal logging by defining the **log4j.debug** variable.
///
/// As of log4j version 0.8.5, at class initialization time class, the file <b>log4j.properties</b> will be searched from the search path used to load classes. If the file can be found, then it will be fed to the {@link PropertyConfigurator#configure(java.net.URL)} method.
///
/// The <code>PropertyConfigurator</code> does not handle the advanced configuration features supported by the {@link org.apache.log4j.xml.DOMConfigurator DOMConfigurator} such as support custom {@link org.apache.log4j.spi.ErrorHandler ErrorHandlers}, nested appenders such as the {@link org.apache.log4j.AsyncAppender AsyncAppender}, etc.
///
/// All option <em>values</em> admit variable substitution. The syntax of variable substitution is similar to that of Unix shells. The string between an opening <b>&quot;${&quot;</b> and closing <b>&quot;}&quot;</b> is interpreted as a key. The value of the substituted variable can be defined as a system property or in the configuration file itself. The value of the key is first searched in the system properties, and if not found there, it is then searched in the configuration file being parsed.  The corresponding value replaces the ${variableName} sequence. For example, if <code>java.home</code> system property is set to <code>/home/xyz</code>, then every occurrence of the sequence <code>${java.home}</code> will be interpreted as <code>/home/xyz</code>.
///
open class PropertyConfigurator: Configurator, Loadable {
    
    /// The properties data
    internal let properties: Properties
    
    /// Using properties to create PropertyConfigurator
    internal init(properties: Properties) {
        self.properties = properties
    }
    
    /// Using data to create PropertyConfigurator
    public init?(data: Data, encoding: String.Encoding = .utf8) {
        guard let contents = String(data: data, encoding: encoding) else {
            return nil
        }
        self.properties = Properties(contents: contents)
    }
    
    /// Using file to create PropertyConfigurator
    public required init?(contentsOf url: URL) {
        guard let contents = try? String(contentsOf: url) else {
            return nil
        }
        self.properties = Properties(contents: contents)
    }

    
    ///
    /// Read configuration from a file. **The existing configuration is not cleared nor reset.** If you require a different behavior, then call resetConfiguration method before calling doConfigure
    ///
    /// The configuration file consists of statements in the format `key=value`. The syntax of different configuration elements are discussed below.
    ///
    ///
    /// # Repository-wide threshold
    ///
    /// The repository-wide threshold filters logging requests by level regardless of logger. The syntax is:
    /// ```
    /// log4j.threshold=[level]
    /// ```
    /// The level value can consist of the string values OFF, FATAL, ERROR, WARN, INFO, DEBUG, ALL or a <em>custom level</em> value. A custom level value can be specified in the form level#classname. By default the repository-wide threshold is set to the lowest possible value, namely the level <code>ALL</code>.
    ///
    ///
    /// # Appender configuration
    ///
    /// Appender configuration syntax is:
    /// ```
    /// # For appender named <i>appenderName</i>, set its class.
    /// # Note: The appender name can contain dots.
    /// log4j.appender.appenderName=fully.qualified.name.of.appender.class
    ///
    /// # Set appender specific options.
    /// log4j.appender.appenderName.option1=value1
    /// ...
    /// log4j.appender.appenderName.optionN=valueN
    /// ```
    ///
    /// For each named appender you can configure its {@link Layout}. The syntax for configuring an appender's layout is:
    /// ```
    /// log4j.appender.appenderName.layout=fully.qualified.name.of.layout.class
    /// log4j.appender.appenderName.layout.option1=value1
    /// ....
    /// log4j.appender.appenderName.layout.optionN=valueN
    /// ```
    ///
    /// The syntax for adding {@link Filter}s to an appender is:
    /// ```
    /// log4j.appender.appenderName.filter.ID=fully.qualified.name.of.filter.class
    /// log4j.appender.appenderName.filter.ID.option1=value1
    /// ...
    /// log4j.appender.appenderName.filter.ID.optionN=valueN
    /// ```
    /// The first line defines the class name of the filter identified by ID; subsequent lines with the same ID specify filter option - value paris. Multiple filters are added to the appender in the lexicographic order of IDs.
    ///
    /// The syntax for adding an {@link ErrorHandler} to an appender is:
    /// ```
    /// log4j.appender.appenderName.errorhandler=fully.qualified.name.of.filter.class
    /// log4j.appender.appenderName.errorhandler.root-ref={true|false}
    /// log4j.appender.appenderName.errorhandler.logger-ref=loggerName
    /// log4j.appender.appenderName.errorhandler.appender-ref=appenderName
    /// log4j.appender.appenderName.errorhandler.option1=value1
    /// ...
    /// log4j.appender.appenderName.errorhandler.optionN=valueN
    /// ```
    ///
    ///
    /// # Configuring loggers
    ///
    /// The syntax for configuring the root logger is:
    /// ```
    /// log4j.rootLogger=[level], appenderName, appenderName, ...
    /// ```
    /// This syntax means that an optional <em>level</em> can be supplied followed by appender names separated by commas.
    ///
    /// The level value can consist of the string values OFF, FATAL, ERROR, WARN, INFO, DEBUG, ALL or a <em>custom level</em> value. A custom level value can be specified in the form <code>level#classname</code>.
    ///
    /// If a level value is specified, then the root level is set to the corresponding level.  If no level value is specified, then the root level remains untouched.
    ///
    /// The root logger can be assigned multiple appenders.
    ///
    /// Each <i>appenderName</i> (separated by commas) will be added to the root logger. The named appender is defined using the appender syntax defined above.
    ///
    /// For non-root categories the syntax is almost the same:
    /// ```
    /// log4j.logger.logger_name=[level|INHERITED|NULL], appenderName, appenderName, ...
    /// ```
    ///
    /// The meaning of the optional level value is discussed above in relation to the root logger. In addition however, the value INHERITED can be specified meaning that the named logger should inherit its level from the logger hierarchy.
    ///
    /// If no level value is supplied, then the level of the named logger remains untouched.
    ///
    /// By default categories inherit their level from the hierarchy. However, if you set the level of a logger and later decide that that logger should inherit its level, then you should specify INHERITED as the value for the level value. NULL is a synonym for INHERITED.
    ///
    /// Similar to the root logger syntax, each <i>appenderName</i> (separated by commas) will be attached to the named logger.
    ///
    /// See the <a href="../../../../manual.html#additivity">appender additivity rule</a> in the user manual for the meaning of the <code>additivity</code> flag.
    ///
    ///
    /// # ObjectRenderers
    /// You can customize the way message objects of a given type are converted to String before being logged. This is done by specifying an {@link org.apache.log4j.or.ObjectRenderer ObjectRenderer} for the object type would like to customize.
    ///
    /// The syntax is:
    /// ```
    /// log4j.renderer.fully.qualified.name.of.rendered.class=fully.qualified.name.of.rendering.class
    /// ```
    /// As in,
    /// ```
    /// log4j.renderer.my.Fruit=my.FruitRenderer
    /// ```
    ///
    ///
    /// # Logger Factories
    /// The usage of custom logger factories is discouraged and no longer documented.
    ///
    ///
    /// # Resetting Hierarchy
    /// The hierarchy will be reset before configuration when log4j.reset=true is present in the properties file.
    ///
    ///
    /// # Example
    /// An example configuration is given below. Other configuration file examples are given in the <code>examples</code> folder.
    ///
    /// ```
    /// # Set options for appender named "A1".
    /// # Appender "A1" will be a SyslogAppender
    /// log4j.appender.A1=org.apache.log4j.net.SyslogAppender
    ///
    /// # The syslog daemon resides on www.abc.net
    /// log4j.appender.A1.SyslogHost=www.abc.net
    ///
    /// # A1's layout is a PatternLayout, using the conversion pattern
    /// # %r %-5p %c{2} %M.%L %x - %m\n. Thus, the log output will
    /// # include # the relative time since the start of the application in
    /// # milliseconds, followed by the level of the log request,
    /// # followed by the two rightmost components of the logger name,
    /// # followed by the callers method name, followed by the line number,
    /// # the nested disgnostic context and finally the message itself.
    /// # Refer to the documentation of {@link PatternLayout} for further information
    /// # on the syntax of the ConversionPattern key.
    /// log4j.appender.A1.layout=org.apache.log4j.PatternLayout
    /// log4j.appender.A1.layout.ConversionPattern=%-4r %-5p %c{2} %M.%L %x - %m\n
    ///
    /// # Set options for appender named "A2"
    /// # A2 should be a RollingFileAppender, with maximum file size of 10 MB
    /// # using at most one backup file. A2's layout is TTCC, using the
    /// # ISO8061 date format with context printing enabled.
    /// log4j.appender.A2=org.apache.log4j.RollingFileAppender
    /// log4j.appender.A2.MaxFileSize=10MB
    /// log4j.appender.A2.MaxBackupIndex=1
    /// log4j.appender.A2.layout=org.apache.log4j.TTCCLayout
    /// log4j.appender.A2.layout.ContextPrinting=enabled
    /// log4j.appender.A2.layout.DateFormat=ISO8601
    ///
    /// # Root logger set to DEBUG using the A2 appender defined above.
    /// log4j.rootLogger=DEBUG, A2
    ///
    /// # Logger definitions:
    /// # The SECURITY logger inherits is level from root. However, it's output
    /// # will go to A1 appender defined above. It's additivity is non-cumulative.
    /// log4j.logger.SECURITY=INHERIT, A1
    /// log4j.additivity.SECURITY=false
    ///
    /// # Only warnings or above will be logged for the logger "SECURITY.access".
    /// # Output will go to A1.
    /// log4j.logger.SECURITY.access=WARN
    ///
    ///
    /// # The logger "class.of.the.day" inherits its level from the
    /// # logger hierarchy.  Output will go to the appender's of the root
    /// # logger, A2 in this case.
    /// log4j.logger.class.of.the.day=INHERIT
    /// ```
    /// Refer to the **setOption** method in each Appender and Layout for class specific options.
    ///
    /// Use the <code>#</code> or <code>!</code> characters at the beginning of a line for comments.
    ///
    open func apply(_ hierarchy: LoggerRepository) {

        var appenders = Dictionary<String, Appender>()
        var loggerFactory = LoggerFactory()

        // "log4j.configDebug" is deprecated
        if let debug = properties.decode(Bool.self, forKey: "log4j.debug") ?? properties.decode(Bool.self, forKey: "log4j.configDebug") {
            LogLog.debugging = debug
        }
        
        if let reset = properties.decode(Bool.self, forKey: "log4j.reset"), reset {
            LogLog.debug("Hierarchy has been reset")
            hierarchy.reset()
        }
        
        if let threshold = properties.decode(Level.self, forKey: "log4j.threshold") {
            LogLog.debug("Hierarchy threshold set to [\(threshold)]")
            hierarchy.threshold = threshold
        }

        // "log4j.rootCategory" is deprecated
        if let names = properties.decode(Level.Names.self, forKey: "log4j.rootLogger") ?? properties.decode(Level.Names.self, forKey: "log4j.rootCategory") {
            if names.level == nil {
                LogLog.warn("The root logger cannot be set to null.")
            }
            
            // If the level value is inherited, set category level value to null.
            // We also check that the user has not specified inherited for the root category.
            hierarchy.root.name = "root"
            hierarchy.root.level = names.level ?? .debug
            
            // Begin by removing all existing appenders.
            hierarchy.root.removeAllAppenders()
            
            // Parse all the appender to the root logger
            for name in names.appenders {
                // If you have been parsed use it
                if let appender = appenders[name] {
                    LogLog.debug("Appender \"\(name)\" was already parsed.");
                    hierarchy.root.appendAppender(appender)
                    break
                }

                // Try to use the name to parse appender
                guard let appender = properties.decode(Appender.self, forKey: "log4j.appender.\(name)") else {
                    break
                }
                
                appender.name = name
                hierarchy.root.appendAppender(appender)
                
                // The marked appender has been parsed
                appenders[name] = appender
            }
        } else {
            LogLog.debug("Could not find root logger information. Is this OK?")
        }
        
        // Key for specifying the {@link org.apache.log4j.spi.LoggerFactory LoggerFactory}.  Currently set to "<code>log4j.loggerFactory</code>".
        if let factory = properties.decode(LoggerFactory.self, forKey: "log4j.loggerFactory") {
            LogLog.debug("Setting logger factory to [\(factory)].")
            loggerFactory = factory
        }
        
        // "log4j.category." is deprecated
        properties.names.forEach {
            // Gets the string after the prefix, that is the logger name.
            guard let name = $0.log4s_prefix("log4j.logger.") ?? $0.log4s_prefix("log4j.category.") else {
                return
            }
            let logger = hierarchy.logger(name, factory: loggerFactory)
            
            // Parse the appender for a non-root logger.
            if let names = properties.decode(Level.Names.self, forKey: $0) {
                // If the level value is inherited, set category level value to null.
                // We also check that the user has not specified inherited for the root category.
                logger.level = names.level ?? .debug
                
                // Begin by removing all existing appenders.
                logger.removeAllAppenders()
                
                // Parse all the appender to the non-root logger
                for name in names.appenders {
                    // If you have been parsed use it
                    if let appender = appenders[name] {
                        LogLog.debug("Appender \"\(name)\" was already parsed.");
                        logger.appendAppender(appender)
                        break
                    }
                    
                    // Try to use the name to parse appender
                    guard let appender = properties.decode(Appender.self, forKey: "log4j.appender.\(name)") else {
                        break
                    }
                    
                    appender.name = name
                    logger.appendAppender(appender)
                    
                    // The marked appender has been parsed
                    appenders[name] = appender
                }
            }
            
            // Parse the additivity option for a non-root logger.
            if let additivity = properties.decode(Bool.self, forKey: "log4j.additivity.\(name)") {
                LogLog.debug("Setting additivity for \"\(name)\" to \(additivity)")
                logger.additivity = additivity
            }
        }

        LogLog.debug("Finished configuring.")
    }
    
    /// The fully qualified name of the class.
    open class var FQCN: String {
        return "org.apache.log4j.PropertyConfigurator"
    }
}
