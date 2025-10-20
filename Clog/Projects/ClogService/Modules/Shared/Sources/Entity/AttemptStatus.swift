//
//  AttemptStatus.swift
//  Shared
//
//  Created by Junyoung on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//


public enum AttemptStatus: String, Equatable {
    case success = "SUCCESS"
    case failure = "FAILURE"
    
    public init(value: String) {
        self = .init(rawValue: value) ?? .success
    }
}
