//
//  ClogDI.swift
//  Clog
//
//  Created by saeng lin on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Swinject

public enum ClogDI: Sendable {
    
    public static let container = Container()
    
    /// Service 단위로 DI 주입
    /// - Parameter assemblies: 서비스 DI 객체
    public static func register(assemblies: [Assembly]) {
        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }
}
