//
//  EditMemoRepository.swift
//  StoryDomain
//
//  Created by Junyoung on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol EditMemoRepository {
    func execute(storyId: Int, memo: String) async throws
}
