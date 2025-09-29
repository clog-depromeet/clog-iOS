//
//  SearchSocialFriendRepository.swift
//  SocialDomain
//
//  Created by soi on 8/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared
import Dependencies

public protocol SearchSocialFriendRepository {
    func loadFirstPage(keyword: String) async throws -> [SocialFriend]
    func loadNextPage(keyword: String) async throws -> [SocialFriend]
}

public enum SearchSocialFriendRepositoryDependencyKey: DependencyKey {
    public static let liveValue = ClogDI.container.resolve(SearchSocialFriendRepository.self)!
}

public extension DependencyValues {
    var searchSocialFriendRepository: SearchSocialFriendRepository {
        get { self[SearchSocialFriendRepositoryDependencyKey.self] }
        set { self[SearchSocialFriendRepositoryDependencyKey.self] = newValue }
    }
}
