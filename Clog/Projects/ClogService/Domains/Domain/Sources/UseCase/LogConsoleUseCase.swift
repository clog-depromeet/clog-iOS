//
//  LogUseCase.swift
//  Domain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared

import Dependencies

public protocol LogConsoleUseCase {
    func executeInfo(label: String, message: String)
    func executeDebug(label: String, message: String)
}

public struct MockLogConsole: LogConsoleUseCase {
    public func executeInfo(label: String, message: String) {
        print("\(#function) : \(label), message : \(message)")
    }
    
    public func executeDebug(label: String, message: String) {
        print("\(#function) : \(label), message : \(message)")
    }
}

public enum LogConsoleDepdencyKey: DependencyKey {
    public static var liveValue: any LogConsoleUseCase = ClogDI.container.resolve(LogConsoleUseCase.self)!
    
//    public static var testValue: any LogConsoleUseCase = MockLogConsole()
    
//    public static var previewValue: any LogConsoleUseCase = MockLogConsole()
}

public extension DependencyValues {
    var logConsole: any LogConsoleUseCase {
        get { self[LogConsoleDepdencyKey.self] }
        set { self[LogConsoleDepdencyKey.self] = newValue }
    }
}
