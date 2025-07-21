//
//  SocialFriendRepository.swift
//  SocialDomain
//
//  Created by soi on 7/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol SocialFriendRepository {
    func fetchFollowers() async throws -> [SocialFriend]
    func fetchFollowings() async throws -> [SocialFriend]
}
