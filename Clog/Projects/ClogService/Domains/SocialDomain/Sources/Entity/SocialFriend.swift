//
//  SocialCellEntity.swift
//  SocialDomain
//
//  Created by 강현준 on 5/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct SocialFriend: Identifiable, Equatable {
    public let id: String
    public let profileImageUrl: String?
    public let nickName: String
    public let tag: String
    public let isFollowing: Bool
    public let isClimbedWithin7Days: Bool
    
    public init(
        id: String,
        profileImageUrl: String?,
        nickName: String,
        tag: String,
        isFollowed: Bool,
        isClimbedWithin7Days: Bool
    ) {
        self.id = id
        self.profileImageUrl = profileImageUrl
        self.nickName = nickName
        self.tag = tag
        self.isFollowing = isFollowed
        self.isClimbedWithin7Days = isClimbedWithin7Days
    }
    
    public func toggleFollowing() -> Self {
        with(isFollowing: !isFollowing)
    }
    
    private func with(
        id: String? = nil,
        profileImageUrl: String? = nil,
        nickName: String? = nil,
        tag: String? = nil,
        isFollowing: Bool? = nil,
        isClimbedWithin7Days: Bool? = nil
    ) -> Self {
        .init(
            id: id ?? self.id,
            profileImageUrl: profileImageUrl ?? self.profileImageUrl,
            nickName: nickName ?? self.nickName,
            tag: tag ?? self.tag,
            isFollowed: isFollowing ?? self.isFollowing,
            isClimbedWithin7Days: isClimbedWithin7Days ?? self.isClimbedWithin7Days
        )
    }
}
