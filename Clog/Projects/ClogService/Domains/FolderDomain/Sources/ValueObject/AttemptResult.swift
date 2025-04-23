//
//  AttemptResult.swift
//  FolderDomain
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public enum AttemptResult: String, CaseIterable {
    case complete = "SUCCESS"
    case fail = "FAILURE"
    
    public var name: String {
        switch self {
        case .complete: "완등"
        case .fail: "실패"
        }
    }
    
    func toggleResult() -> AttemptResult {
        switch self {
        case .complete: .fail
        case .fail:     .complete
        }
    }
}

