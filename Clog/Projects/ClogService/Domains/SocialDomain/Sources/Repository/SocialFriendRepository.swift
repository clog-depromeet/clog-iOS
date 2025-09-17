//
//  SocialFriendRepository.swift
//  SocialDomain
//
//  Created by soi on 7/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared

import Dependencies

public protocol SocialFriendRepository {
    func fetchFollowers() async throws -> [SocialFriend]
    func fetchFollowings() async throws -> [SocialFriend]
    func followUser(userId: String) async throws -> Bool
    func unfollowUser(userId: String) async throws -> Bool
}

public enum SocialFriendRepositoryDependencyKey: DependencyKey {
    public static let liveValue = ClogDI.container.resolve(SocialFriendRepository.self)!
}

public extension DependencyValues {
    var socialFriendRepository: SocialFriendRepository {
        get { self[SocialFriendRepositoryDependencyKey.self] }
        set { self[SocialFriendRepositoryDependencyKey.self]  = newValue }
    }
}
