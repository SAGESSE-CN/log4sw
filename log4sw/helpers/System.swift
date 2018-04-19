//
//  System.swift
//  log4sw
//
//  Created by sagesse on 2018/4/19.
//  Copyright © 2018 SAGESSE. All rights reserved.
//

import Cocoa


// java.version Java 运行时环境版本
// java.vendor Java 运行时环境供应商
// java.vendor.url Java 供应商的 URL
// java.home Java 安装目录
// java.vm.specification.version Java 虚拟机规范版本
// java.vm.specification.vendor Java 虚拟机规范供应商
// java.vm.specification.name Java 虚拟机规范名称
// java.vm.version Java 虚拟机实现版本
// java.vm.vendor Java 虚拟机实现供应商
// java.vm.name Java 虚拟机实现名称
// java.specification.version Java 运行时环境规范版本
// java.specification.vendor Java 运行时环境规范供应商
// java.specification.name Java 运行时环境规范名称
// java.class.version Java 类格式版本号
// java.class.path Java 类路径
// java.library.path 加载库时搜索的路径列表
// java.io.tmpdir 默认的临时文件路径
// java.compiler 要使用的 JIT 编译器的名称
// java.ext.dirs 一个或多个扩展目录的路径
// os.name 操作系统的名称
// os.arch 操作系统的架构
// os.version 操作系统的版本
// file.separator 文件分隔符（在 UNIX 系统中是"/"）
// path.separator 路径分隔符（在 UNIX 系统中是":"）
// line.separator 行分隔符（在 UNIX 系统中是"/n"）
// user.name 用户的账户名称
// user.home 用户的主目录
// user.dir 用户的当前工作目录


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
    static func env(for key: String) throws -> String? {
        switch key {
        case "":
            throw IllegalArgumentException("key is empty")
            
        case "java.io.tmpdir":
            return NSTemporaryDirectory()
            
        case "user.dir":
            let lenght = 8096
            let buf = UnsafeMutablePointer<Int8>.allocate(capacity: lenght)
            
            guard getcwd(buf, lenght) != nil else {
                return nil
            }
            
            return String(utf8String: buf)

        default:
            guard let value = getenv(key) else {
                return nil
            }
            return String(utf8String: value)
        }
    }
}
