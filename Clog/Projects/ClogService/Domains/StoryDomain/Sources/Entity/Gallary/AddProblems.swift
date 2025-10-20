//
//  AddProblems.swift
//  StoryDomain
//
//  Created by soi on 6/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared

public struct AddProblems {
    public let date: String
    public let cragId: Int?
    public let memo: String?
    public let videos: [VideoRequest]
    
    public init(
        date: String,
        cragId: Int?,
        memo: String?,
        videos: [VideoRequest]
    ) {
        self.date = date
        self.cragId = cragId
        self.memo = memo
        self.videos = videos
    }
}
