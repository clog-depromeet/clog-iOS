//
//  ReadAttemptDetail.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct ReadAttemptDetail: Hashable, Equatable {
    public let status: AttemptResult
    public let video: AttemptVideo
    
    public init(
        status: AttemptResult,
        video: AttemptVideo
    ) {
        self.status = status
        self.video = video
    }
}
