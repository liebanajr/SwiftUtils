//
//  Logger.swift
//  watchOSUtils
//
//  Created by Juan Rodríguez on 4/1/21.
//

import Foundation

enum LOGLEVEL{
    case TRACE
    case DEBUG
    case INFO
    case WARNING
    case ERROR
}

public struct Log {
    
    #if DEBUG
    static let minLogLevel : LOGLEVEL = .TRACE
    #else
    static let minLogLevel : LOGLEVEL = .WARNING
    #endif
        
    public static func trace(_ message: String){
        if minLogLevel == .TRACE {
            print("\(Date()) 🔘 - \(message)")
        }
    }
    
    public static func debug(_ message: String){
        if minLogLevel == .DEBUG || minLogLevel == .TRACE {
            print("\(Date()) 🐜 - \(message)")
        }
    }
    
    public static func info(_ message: String){
        if minLogLevel == .TRACE || minLogLevel == .INFO || minLogLevel == .DEBUG{
            print("\(Date()) ℹ️ - \(message)")
        }
    }
    
    public static func warning(_ message: String){
        if minLogLevel == .TRACE || minLogLevel == .INFO || minLogLevel == .WARNING || minLogLevel == .DEBUG {
            print("\(Date()) ⚠️ - \(message)")
        }
    }
    
    public static func error(_ message: String, callFunctionName : String = #function, callFileName : String = #file, callLine : Int = #line){
        print("\(Date()) ❌ - \(message) - 🕵️‍♀️ File: \(callFileName), Line: \(callLine)")
    }

}
