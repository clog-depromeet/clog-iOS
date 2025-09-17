//
//  SocialFriendRepository.swift
//  Data
//
//  Created by soi on 7/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SocialDomain

public struct DefaultSocialFriendRepository: SocialFriendRepository {
    private let dataSource: SocialFriendDataSource
    
    public init(dataSource: SocialFriendDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetchFollowers() async throws -> [SocialFriend] {
        try await dataSource.followers().map { $0.toDomain() }
    }
    
    public func fetchFollowings() async throws -> [SocialFriend] {
        try await dataSource.followings().map { $0.toDomain() }
    }

    public func followUser(user: SocialFriend) async throws -> SocialFriend {
        let result = try await dataSource.followUser(userId: user.id)
        return user.toggleFollowing()
    }

    public func unfollowUser(user: SocialFriend) async throws -> SocialFriend {
        let result = try await dataSource.unfollowUser(userId: user.id)
        return user.toggleFollowing()
    }
}
