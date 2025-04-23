//
//  Clogger.swift
//  Clog
//
//  Created by saeng lin on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Domain

import Starlink
import Pulse
import Swinject
import Shared

public struct Clogger {
    
    public init() {}
    
    public func message(
        label: String = "",
        level: LoggerStore.Level = .info,
        message: String
    ) {
        ConsoleWindow.shared.message(
            label: label,
            level: level,
            message: message)
    }
}

extension Clogger: Assembly {
    
    public func assemble(container: Container) {
        container.register(LogConsoleUseCase.self) { _ in
            return Clogger()
        }
    }
}

extension Clogger: LogConsoleUseCase {
    
    public func executeInfo(label: String, message: String) {
        self.message(label: label, level: .info, message: message)
    }
    
    public func executeDebug(label: String, message: String) {
        self.message(label: label, level: .debug, message: message)
    }
}
