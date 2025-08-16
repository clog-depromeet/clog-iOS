//
//  SearchSocialFriendUseCase.swift
//  SocialDomain
//
//  Created by soi on 8/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol SearchSocialFriendUseCase {
    func loadFirstPage(keyword: String?) async throws -> [SocialFriend]
    func loadNextPage(keyword: String?) async throws -> [SocialFriend]
}

public final class DefaultSearchSocialFriendUseCase: SearchSocialFriendUseCase {
    private let repository: SocialFriendRepository
    
    private var currentCursor: Double? = nil
    private var hasMore: Bool = true
    
    public init(repository: SocialFriendRepository) {
        self.repository = repository
    }
    
    public func loadFirstPage(keyword: String?) async throws -> [SocialFriend] {
        currentCursor = nil
        hasMore = true
        return try await loadNextPage(keyword: keyword)
    }
    
    public func loadNextPage(keyword: String?) async throws -> [SocialFriend] {
        guard hasMore else { return [] }
        
        let result = try await repository.users(cursor: currentCursor, keyword: keyword)
        currentCursor = result.nextCursor
        hasMore = result.hasMore
        
        return result.items
    }
}

public enum SearchSocialFriendUseCaseDependencyKey: DependencyKey {
    public static let liveValue = ClogDI.container.resolve(SearchSocialFriendUseCase.self)!
}

public extension DependencyValues {
    var searchSocialFriendUseCase: SearchSocialFriendUseCase {
        get { self[SearchSocialFriendUseCaseDependencyKey.self] }
        set { self[SearchSocialFriendUseCaseDependencyKey.self] = newValue }
    }
}

