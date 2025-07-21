//
//  SocialFriendResponseDTO.swift
//  Data
//
//  Created by soi on 7/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SocialDomain

public struct SocialFriendResponseDTO: Decodable {
    let id: Int
    let name: String
    let armSpan: Int?
    let instagramUrl: String?
    let isFollowing: Bool
    
    func toDomain() -> SocialFriend {
        .init(
            id: String(id),
            profileImageUrl: "",
            nickName: name,
            tag: "",
            isFollowed: isFollowing,
            isClimbedWithin7Days: true
        )
    }
}
