//
//  SocialFriendListCell.swift
//  SocialFeature
//
//  Created by 강현준 on 5/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SwiftUI
import SocialDomain
import DesignKit

public struct SocialFriendListCell: View {
    
    private let friend: SocialFriend
    private let onFollowTap: () -> Void
    private let onMoreTap: (() -> Void)?
    
    public init(
        friend: SocialFriend,
        onFollowTap: @escaping () -> Void,
        onMoreTap: (() -> Void)? = nil
    ) {
        self.friend = friend
        self.onFollowTap = onFollowTap
        self.onMoreTap = onMoreTap
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            
            SocialProfileImageView(friend: friend)
            
            Spacer()
                .frame(width: 12)
            
            Group{
                Text(friend.nickName)
                    .foregroundStyle(Color.clogUI.white)
                
                Spacer()
                    .frame(width: 4)
                
                Text(friend.tag)
                    .foregroundStyle(Color.clogUI.gray400)
            }
            .font(.b1)
            
            Spacer()
            
            Button {
                onFollowTap()
            } label: {
                HStack {
                    Text(friend.isFollowing == true ? "팔로잉" : "팔로우")
                        .font(.b2)
                        .foregroundStyle(
                            friend.isFollowing == true
                            ? Color.clogUI.white
                            : Color.clogUI.gray800
                        )
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    friend.isFollowing == true
                    ? Color.clogUI.gray600
                    : Color.clogUI.white
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer()
                .frame(width: 12)
            
            if let action = onMoreTap {
                Button {
                    action()
                } label: {
                    Image.clogUI.icn_dot_vertical
                        .resizable()
                        .frame(20)
                }
            }
                
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
    }
}
