//
//  SearchSocialFriendRepository.swift
//  Data
//
//  Created by soi on 8/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SocialDomain

public final class DefaultSearchSocialFriendRepository: SearchSocialFriendRepository {
    private let dataSource: UserDataSource
    
    public init(dataSource: UserDataSource) {
        self.dataSource = dataSource
    }
    
    private var currentCursor: Double? = nil
    private var hasMore: Bool = true
    
    public func loadFirstPage(keyword: String) async throws -> [SocialFriend] {
        currentCursor = nil
        hasMore = true
        return try await loadNextPage(keyword: keyword)
    }
    
    public func loadNextPage(keyword: String) async throws -> [SocialFriend] {
        guard hasMore else { return [] }
        
        let result = try await dataSource.search(cursor: currentCursor, keyword: keyword)
        currentCursor = result.meta?.nextCursor
        hasMore = result.meta?.hasMore ?? false
        
        return result.items?.map { $0.toDomain() } ?? []
    }
}
