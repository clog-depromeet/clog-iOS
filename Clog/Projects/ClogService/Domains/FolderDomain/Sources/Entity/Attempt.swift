//
//  Attempt.swift
//  FolderDomain
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct Attempt: Hashable, Identifiable {
    public var id: Int
    public let date: String
    public let grade: Grade?
    public let result: AttemptResult
    public let thumbnailUrl: String?
    public let recordedTime: String
    public let crag: Crag?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    public init(
        id: Int,
        date: String,
        grade: Grade?,
        result: AttemptResult,
        thumbnailUrl: String?,
        recordedTime: String,
        crag: Crag?
    ) {
        self.id = id
        self.date = date
        self.grade = grade
        self.result = result
        self.thumbnailUrl = thumbnailUrl
        self.recordedTime = recordedTime
        self.crag = crag
    }
}
