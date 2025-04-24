//
//  FilterableAttemptInfo.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct FilterableAttemptInfo: Hashable, Identifiable {
    public var id: UUID
    
    public let crags: [Crag]
    public let grades: [Grade]
    
    init(id: UUID = UUID(), crags: [Crag], grades: [Grade]) {
        self.id = id
        self.crags = crags
        self.grades = grades
    }
}
