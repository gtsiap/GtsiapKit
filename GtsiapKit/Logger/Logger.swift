//
//  Logger.swift
//  atlas-ios
//
//  Created by Giorgos Tsiapaliokas on 5/5/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//


public class Logger {
    // MARK: vars
    public let showFile: Bool
    public let showFunc: Bool
    public let showLine: Bool
    public let categories: [String]
    public static var globalCategories: [String]?

    init(showFile: Bool, showFunc: Bool, showLine: Bool, categories: [String]) {
        self.showFile = showFile
        self.showFunc = showFunc
        self.showLine = showLine
        self.categories = categories
    }

    public class func defaultLogger(categories: [String]) -> Logger{
        let logger = Logger(showFile: true, showFunc: true, showLine: true, categories: categories)
        return logger
    }

    // MARK: public func
    public func debug(msg: Any, file: String = __FILE__,
        funcString: String = __FUNCTION__, line: Int = __LINE__) {

        if Logger.globalCategories == nil {
            return
        }

        for it in categories {
            if contains(Logger.globalCategories!, it) {
                let format = formatDebug(it, file: file, funcString: funcString, line: line)
                println("\(format)\(msg)")
                println()
                return
            }
        }
    }

    // MARK: private func
    private func formatDebug(category: String, file: String, funcString: String, line: Int) -> String {
        return "(\(category))[\(file.pathComponents.last!):\(line)] \(funcString): "
    }

}
