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
}

public final class DefaultSocialFriendDataSource: SocialFriendDataSource {
    private let provider: MoyaProvider<DefaultSocialFriendDataSource.Target> = MoyaProvider<DefaultSocialFriendDataSource.Target>.authorized()
    // dataSource
    public init() {}
    
    public func followings() async throws -> [SocialFriendResponseDTO] {
        let response: BaseResponseDTO<[SocialFriendResponseDTO]> = try await provider.request(.followings)
        guard let followings = response.data else {
            throw NetworkError.decoding
        }
        return followings
    }
    
    public func followers() async throws -> [SocialFriendResponseDTO] {
        let response: BaseResponseDTO<[SocialFriendResponseDTO]> = try await provider.request(.followers)
        guard let followings = response.data else {
            throw NetworkError.decoding
        }
        return followings
    }
}

extension DefaultSocialFriendDataSource {
    enum Target: TargetType {
        case followings
        case followers
        
        var baseURL: URL {
            return URL(string: Environment.baseURL + "/api/v1/users/me")!
        }
        
        var path: String {
            switch self {
                case .followings:
                return "/followings"
            case .followers:
                return "/followers"
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .followers, .followings: .get
            }
        }
        
        var task: Task {
            switch self {
            case .followers, .followings: .requestPlain
            }
        }
    }
}
