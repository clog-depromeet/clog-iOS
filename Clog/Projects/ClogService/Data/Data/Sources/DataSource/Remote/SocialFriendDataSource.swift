//
//  SocialFriendDataSource.swift
//  Data
//
//  Created by soi on 7/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Moya

public protocol SocialFriendDataSource {
    func followings() async throws -> [SocialFriendResponseDTO]
    func followers() async throws -> [SocialFriendResponseDTO]
    func followUser(userId: String) async throws -> Bool
    func unfollowUser(userId: String) async throws -> Bool
}

public final class DefaultSocialFriendDataSource: SocialFriendDataSource {
    private let provider: MoyaProvider<DefaultSocialFriendDataSource.Target> = MoyaProvider<DefaultSocialFriendDataSource.Target>.authorized()
    // dataSource
    public init() {}
    
    public func followings() async throws -> [SocialFriendResponseDTO] {
        let response: BaseResponseDTO<[SocialFriendResponseDTO]> = try await provider.request(.followings)
        return response.data ?? []
    }

    public func followers() async throws -> [SocialFriendResponseDTO] {
        let response: BaseResponseDTO<[SocialFriendResponseDTO]> = try await provider.request(.followers)
        return response.data ?? []
    }

    public func followUser(userId: String) async throws -> Bool {
        let result: BaseResponseDTO<Bool> = try await provider.request(.follow(userId: userId))
        return result.data ?? false
    }

    public func unfollowUser(userId: String) async throws -> Bool {
        let result: BaseResponseDTO<Bool> = try await provider.request(.unfollow(userId: userId))
        return result.data ?? false
    }
}

extension DefaultSocialFriendDataSource {
    enum Target: TargetType {
        case followings
        case followers
        case follow(userId: String)
        case unfollow(userId: String)
        
        var baseURL: URL {
            return URL(string: Environment.baseURL + "/api/v1/users/me")!
        }
        
        var path: String {
            switch self {
            case .followings:
                return "/followings"
            case .followers:
                return "/followers"
            case .follow(let userId), .unfollow(let userId):
                return "/followings/\(userId)"
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .followers, .followings:
                return .get
            case .follow:
                return .post
            case .unfollow:
                return .delete
            }
        }
        
        var task: Task {
            switch self {
            case .followers, .followings, .follow, .unfollow:
                return .requestPlain
            }
        }
    }
}
