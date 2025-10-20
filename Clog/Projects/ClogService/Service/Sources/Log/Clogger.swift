//
//  Clogger.swift
//  Clog
//
//  Created by saeng lin on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Domain

import Swinject
import Shared

public struct Clogger {
    
    public init() {}
    
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
    }
    
    public func executeDebug(label: String, message: String) {
    }
}
