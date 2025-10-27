//
//  SocialProfileImageView.swift
//  DesignKit
//
//  Created by 강현준 on 5/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct SocialProfileImageView: View {
    
    private let isClimbedWithin7Days: Bool
    private let profileImageUrl: String?
    private let size: CGFloat
    
    public init(
        isClimbedWithin7Days: Bool,
        profileImageUrl: String?,
        size: CGFloat = 40
    ) {
        self.isClimbedWithin7Days = isClimbedWithin7Days
        self.profileImageUrl = profileImageUrl
        self.size = size
    }
    
    public var body: some View {
        AsyncImage(url: URL(string: profileImageUrl ?? "")) { state in
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
            isClimbedWithin7Days
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
