//
//  StoryAttempt.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

// 클라이밍 시도 정보
public struct StoryAttempt: Hashable, Equatable {
    public let id: Int
    public let status: AttemptStatus
    public let video: StoryVideo
    
    public init(
        id: Int,
        status: AttemptStatus,
        video: StoryVideo
    ) {
        self.id = id
        self.status = status
        self.video = video
    }
}
