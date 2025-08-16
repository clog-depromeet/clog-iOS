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
    func users(cursor: Double?, keyword: String?) async throws -> (items: [SocialFriendResponseDTO]?, meta: BaseMetaResponseDTO?)
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
    
    public func users(
        cursor: Double?,
        keyword: String?
    ) async throws -> (items: [SocialFriendResponseDTO]?, meta: BaseMetaResponseDTO?) {
        let response: BaseResponseDTO<BaseContentsResponse<[SocialFriendResponseDTO], BaseMetaResponseDTO>> = try await provider.request(
            .users(
                cursor: cursor,
                keyword: keyword
            )
        )
        
        return (response.data?.contents, response.data?.meta)
    }
}

extension DefaultSocialFriendDataSource {
    enum Target: TargetType {
        case followings
        case followers
        case users(cursor: Double?, keyword: String?)
        
        var baseURL: URL {
            return URL(string: Environment.baseURL + "/api/v1/users/me")!
        }
        
        var path: String {
            switch self {
                case .followings:
                return "/followings"
            case .followers:
                return "/followers"
            case .users:
                return "/users"
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .followers, .followings, .users: .get
            }
        }
        
        var task: Task {
            switch self {
            case .followers, .followings:
                return .requestPlain
                
            case .users(let cursor, let keyword):
                let parameters: [String: Any?] = [
                    "cursor": cursor,
                    "keyword": keyword
                ]
                return .requestParameters(
                    parameters: parameters.compactMapValues { $0 },
                    encoding: URLEncoding.default
                )
            }
        }
    }
}
