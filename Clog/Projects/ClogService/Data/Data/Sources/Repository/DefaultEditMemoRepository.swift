//
//  DefaultEditMemoRepository.swift
//  Data
//
//  Created by Junyoung on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

public struct DefaultEditMemoRepository: EditMemoRepository {
    private let dataSource: StoriesDataSource
    
    public init(dataSource: StoriesDataSource) {
        self.dataSource = dataSource
    }
    
    public func execute(storyId: Int, memo: String) async throws {
        let request = EditMemoRequestDTO(storyId: storyId, body: EditMemoRequestBody(memo: memo))
        return try await dataSource.memo(request)
    }
}
