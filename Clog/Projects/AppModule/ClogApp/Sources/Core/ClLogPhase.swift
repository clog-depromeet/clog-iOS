//
//  ClogPhase.swift
//  Clog
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ClogService
import Starlink

@frozen public enum ClogPhase: String, Sendable {
    
    case dev = "dev"
    case production = "production"
    
    public var prefix: String {
        switch self {
        case .dev:
            return "dev-"
            
        case .production:
            return ""
        }
    }
    
    private static var _current: ClogPhase?
    
    public static var current: ClogPhase {
        get {
            if _current == nil {
                _current = .production
            }
            return _current!
        }
        set {
            _current = newValue
        }
    }
    
    static func main() {
        // otherLink를 추가해서 #if로 구현해도 괜찮음
        #if Dev
        ClogPhase.current = .dev
        PulseManager.onPulse()
        #elseif Prod
        ClogPhase.current = .production
        #endif
        Clogger().message(
            label: "[\(Self.self)]\(#function)",
            level: .info,
            message: "[\(Self.self)][Phase] => \(ClogPhase.current)"
        )
    }
}
