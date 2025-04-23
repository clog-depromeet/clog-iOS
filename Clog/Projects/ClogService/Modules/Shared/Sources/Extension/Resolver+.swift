//
//  Resolver+.swift
//  Shared
//
//  Created by soi on 4/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Swinject

extension Resolver {
    public func resolveDependency<T>() -> T {
        guard let dependency = resolve(T.self) else {
            fatalError("\(T.self) dependency could not be resolved")
        }
        return dependency
    }
}
