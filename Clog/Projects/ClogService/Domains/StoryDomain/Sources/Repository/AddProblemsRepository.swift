//
//  AddProblemsRepository.swift
//  StoryDomain
//
//  Created by soi on 6/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol AddProblemsRepository {
    func execute(_ problems: AddProblems) async throws
}
