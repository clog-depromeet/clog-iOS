//
//  StoryStamp.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// 클라이밍 스탬프 정보
public struct StoryStamp: Hashable, Equatable {
    public let id: Int
    public let timeMs: Int
    
    public init(
        id: Int,
        timeMs: Int
    ) {
        self.id = id
        self.timeMs = timeMs
    }
}
