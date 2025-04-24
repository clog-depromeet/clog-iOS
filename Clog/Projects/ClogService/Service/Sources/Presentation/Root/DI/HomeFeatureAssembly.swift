//
//  HomeFeatureAssembly.swift
//  Clog
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Domain

import Swinject

public struct HomeFeatureAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        
        container.register(RootFeature.self) { resolver in
            
            guard let logConsoleUseCase  = resolver.resolve(LogConsoleUseCase.self) else {
                fatalError("Could not resolve LogUseCase")
            }
            
            return RootFeature()
        }
    }
    
    
}
