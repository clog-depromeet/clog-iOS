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
    public var isFollowing: Bool
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
    
    public static func dummy() -> [Self] {
        return [
            SocialFriend(
                id: "user_001",
                profileImageUrl: "https://example.com/images/user1.jpg",
                nickName: "홍길동",
                tag: "@hong",
                isFollowed: true,
                isClimbedWithin7Days: true
            ),
            SocialFriend(
                id: "user_002",
                profileImageUrl: nil,
                nickName: "김철수",
                tag: "@chulsoo",
                isFollowed: false,
                isClimbedWithin7Days: false
            ),
            SocialFriend(
                id: "user_003",
                profileImageUrl: "https://example.com/images/user3.jpg",
                nickName: "이영희",
                tag: "@younghee",
                isFollowed: true,
                isClimbedWithin7Days: true
            ),
            SocialFriend(
                id: "user_004",
                profileImageUrl: nil,
                nickName: "박준형",
                tag: "@joon",
                isFollowed: false,
                isClimbedWithin7Days: false
            ),
            SocialFriend(
                id: "user_005",
                profileImageUrl: "https://example.com/images/user5.jpg",
                nickName: "최수지",
                tag: "@suzy",
                isFollowed: true,
                isClimbedWithin7Days: false
            ),
            SocialFriend(
                id: "user_006",
                profileImageUrl: "https://example.com/images/user6.jpg",
                nickName: "정우성",
                tag: "@woosung",
                isFollowed: true,
                isClimbedWithin7Days: true
            ),
            SocialFriend(
                id: "user_007",
                profileImageUrl: "https://example.com/images/user7.jpg",
                nickName: "한지민",
                tag: "@jimin",
                isFollowed: false,
                isClimbedWithin7Days: true
            ),
            SocialFriend(
                id: "user_008",
                profileImageUrl: "https://example.com/images/user8.jpg",
                nickName: "유재석",
                tag: "@jaeseok",
                isFollowed: false,
                isClimbedWithin7Days: false
            )
        ]
    }
}
