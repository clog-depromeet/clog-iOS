//
//  CalendarStory.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct CalendarStory: Hashable {
    public static func == (lhs: CalendarStory, rhs: CalendarStory) -> Bool {
        rhs.id == lhs.id
    }
    
    public let id: Int
    public let totalDurationMs: Int
    public let cragName: String
    public let thumbnailUrl: String?
    public let problems: [CalendarProblem]
    
    public init(
        id: Int,
        totalDurationMs: Int,
        cragName: String,
        thumbnailUrl: String?,
        problems: [CalendarProblem]
    ) {
        self.id = id
        self.totalDurationMs = totalDurationMs
        self.cragName = cragName
        self.thumbnailUrl = thumbnailUrl
        self.problems = problems
    }
}
