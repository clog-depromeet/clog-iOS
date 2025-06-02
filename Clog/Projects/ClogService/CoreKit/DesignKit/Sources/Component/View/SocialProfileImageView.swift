//
//  SocialProfileImageView.swift
//  DesignKit
//
//  Created by 강현준 on 5/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import SocialDomain

public struct SocialProfileImageView: View {
    
    private let friend: SocialFriend
    private let size: CGFloat
    
    public init(friend: SocialFriend, size: CGFloat = 40) {
        self.friend = friend
        self.size = size
    }
    
    public var body: some View {
        AsyncImage(url: URL(string: friend.profileImageUrl ?? "")) { state in
            switch state {
            case .empty:
                baseProfileImage
            case .success(let image):
                image
                    .resizable()
                    .frame(size)
                    .clipShape(Circle())
                
            case .failure:
                baseProfileImage
                
            @unknown default:
                baseProfileImage
            }
        }
        .overlay(
            friend.isClimbedWithin7Days
            ? AnyView(Image.clogUI.status)
            : AnyView(Color.clear)
            , alignment: .topTrailing)
    }
    
    var baseProfileImage: some View {
        Image.clogUI.defaultProfile
            .resizable()
            .frame(size)
            .clipShape(Circle())
    }
}
