//
//  SaveAttemptRepository.swift
//  VideoDomain
//
//  Created by Junyoung on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol SaveAttemptRepository {
    func register(_ request: AttemptRequest) async throws
}
