//
//  Hierarchy.swift
//  Log4s
//
//  Created by sagesse on 2018/5/10.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Foundation

///
/// This class is specialized in retrieving loggers by name and also maintaining the logger hierarchy.
///
/// <em>The casual user does not have to deal with this class directly.</em>
///
/// The structure of the logger hierarchy is maintained by the
/// {@link #getLogger} method. The hierarchy is such that children link
/// to their parent but parents do not have any pointers to their
/// children. Moreover, loggers can be instantiated in any order, in
/// particular descendant before ancestor.
///
/// In case a descendant is created before a particular ancestor,
/// then it creates a provision node for the ancestor and adds itself
/// to the provision node. Other descendants of the same ancestor add
/// themselves to the previously created provision node.
///
open class Hierarchy: LoggerRepository {
    
    private enum ProvisionNode {
        case none
        case some(Logger)
        case placeholder(Array<Logger>)
    }
    
    ///
    /// Create a new logger hierarchy.
    ///
    /// - parameter root: The root of the new hierarchy.
    ///
    public init(root: Logger) {
        self.root = root
        self.root.hierarchy = self
    }
    
    
    /// All logging requests below the threshold are immediately dropped.
    open var threshold: Level = .all // defaults is all
    
    
    /// Returns root logger for this repository
    open var root: Logger
    
    /// Returns all logger for this repository
    open var loggers: [Logger] {
        // The accumlation in v is necessary because not all elements in
        // ht are Logger objects as there might be some ProvisionNodes
        // as well.
        return _nodes.compactMap {
            switch $1 {
            case .some(let logger):
                return logger
                
            default:
                return nil
            }
        }
    }
    
    
    /// Returns logger of a specified name for this repository
    open func logger(_ name: String) -> Logger {
        return logger(name, factory: _factory)
    }
    
    /// Return a new logger instance named as the first parameter using **factory**.
    open func logger(_ name: String, factory: LoggerFactory) -> Logger {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }

        // Check ProvisionNode status
        switch _nodes[name.lowercased()] ?? .none {
        case .none:
            // Create a new logger will be instantiated by the <code>factory</code> parameter and linked with its existing ancestors as well as children.
            let logger = factory.logger(name)
            
            logger.parent = root
            logger.hierarchy = self

            // Cache the logger with name
            _nodes[name.lowercased()] = .some(logger)
            _updateLoggerParents(for: logger)
            
            return logger
            
        case .placeholder(let children):
            // Create a new logger will be instantiated by the <code>factory</code> parameter and linked with its existing ancestors as well as children.
            let logger = factory.logger(name)
            
            logger.parent = root
            logger.hierarchy = self
            
            // Cache the logger with name
            _nodes[name.lowercased()] = .some(logger)
            _updateLoggerChildren(children, logger: logger)
            _updateLoggerParents(for: logger)
            
            return logger
            
        case .some(let logger):
            // If a logger of that name already exists, then it will be returned
            return logger
        }
    }
    
    
    /// Check if the named logger exists in the hierarchy.
    open func exists(_ name: String) -> Logger? {
        switch _nodes[name.lowercased()] ?? .none {
        case .some(let logger):
            return logger
            
        default:
            return nil
        }
    }
    
    
    ///
    /// Reset all values contained in this hierarchy instance to their default.
    /// This removes all appenders from all categories, sets the level of all non-root categories to <code>null</code>, sets their additivity flag to <code>true</code> and sets the level of the root logger to {@link Level#DEBUG DEBUG}.  Moreover, message disabling is set its default "off" value.
    ///
    /// Existing categories are not removed. They are just reset.
    ///
    /// This method should be used sparingly and with care as it will block all logging until it is completed.
    ///
    open func reset() {
        // Reset hierarchy configure
        threshold = .all
        
        // Reset root logger configure
        root.level = .debug
        root.additivity = true
        //root.boundle = nil
        
        shutdown() // nested locks are OK
        
        // Reset non-root logger configure
        loggers.forEach {
            $0.level = nil
            $0.additivity = true
            //$0.boundle = nil
        }
    }
    
    ///
    /// Shutting down a hierarchy will <em>safely</em> close and remove all appenders in all categories including the root logger.
    ///
    /// Some appenders such as {@link org.apache.log4j.net.SocketAppender} and {@link AsyncAppender} need to be closed before the application exists. Otherwise, pending logging events might be lost.
    ///
    /// The <code>shutdown</code> method is careful to close nested appenders before closing regular appenders. This is allows configurations where a regular appender is attached to a logger and again to a nested appender.
    ///
    open func shutdown() {
        // begin by closing nested appenders
        root.closeNestedAppenders()
        loggers.forEach {
            $0.closeNestedAppenders()
        }
        
        // then, remove all appenders
        root.removeAllAppenders()
        loggers.forEach {
            $0.removeAllAppenders()
        }
    }
    
    /// Report warning message into this repository
    open func warning(forNoAppender logger: Logger) {
        // No appenders in hierarchy, warn user only once.
        if !_noAppenderWarning {
            _noAppenderWarning = true
            
            LogLog.warn("No appenders could be found for logger (\(logger.name).")
            LogLog.warn("Please initialize the log4j system properly.")
            LogLog.warn("See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.")
        }
    }
    
    
    /// Add hierarchy observer
    open func addHierarchyObserver(_ observer: Any) {
    }
    
    /// Remove hierarchy observer
    open func removeHierarchyObserver(_ observer: Any) {
    }
    
    
    ///
    /// This method loops through all the *potential* parents of
    /// 'cat'. There 3 possible cases:
    ///
    /// 1) No entry for the potential parent of 'cat' exists
    ///
    /// We create a ProvisionNode for this potential parent and insert
    /// 'cat' in that provision node.
    ///
    /// 2) There entry is of type Logger for the potential parent.
    ///
    /// The entry is 'cat's nearest existing parent. We update cat's
    /// parent field with this entry. We also break from the loop
    /// because updating our parent's parent is our parent's
    /// responsibility.
    ///
    /// 3) There entry is of type ProvisionNode for this potential parent.
    ///
    /// We add 'cat' to the list of children for this potential parent.
    ///
    private func _updateLoggerParents(for cat: Logger) {
        // Logger name case insensitive
        var name = cat.name.lowercased()
        
        // If name = "w.x.y.z", loop thourgh "w.x.y", "w.x" and "w", but not "w.x.y.z"
        while let range = name.range(of: ".", options:.backwards) {
            // Truncate the nodes that have been processed
            name = .init(name.prefix(upTo: range.lowerBound))
            
            // Check ProvisionNode status
            switch _nodes[name] ?? .none {
            case .none:
                // Create a provision node for a future parent.
                _nodes[name] = .placeholder([cat])

            case .placeholder(let children):
                // The provision node is exists, add to queue.
                _nodes[name] = .placeholder(children + [cat])
                
            case .some(let logger):
                // Parent node has been found
                // No need to update the ancestors of the closest ancestor
                cat.parent = logger
                return
            }
        }
    }

    ///
    /// We update the links for all the children that placed themselves
    /// in the provision node 'pn'. The second argument 'cat' is a
    /// reference for the newly created Logger, parent of all the
    /// children in 'pn'
    ///
    /// We loop on all the children 'c' in 'pn':
    ///
    /// If the child 'c' has been already linked to a child of
    /// 'cat' then there is no need to update 'c'.
    ///
    /// Otherwise, we set cat's parent field to c's parent and set
    /// c's parent field to cat.
    ///
    private func _updateLoggerChildren(_ children: Array<Logger>, logger: Logger) {
        // Unless this child already points to a correct (lower) parent,
        // make cat.parent point to l.parent and l.parent to cat.
        children.forEach {
            logger.parent = $0.parent
            $0.parent = logger
        }

    }
    
    private var _nodes: Dictionary<String, ProvisionNode> = [:]
    private var _factory: LoggerFactory = .init()
    
    private var _noAppenderWarning: Bool = false
}

