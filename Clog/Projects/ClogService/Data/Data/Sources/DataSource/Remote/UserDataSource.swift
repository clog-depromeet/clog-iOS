//
//  UserDataSource.swift
//  Data
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Networker
import Moya

public protocol UserDataSource {
    func leave(_ request: AppleWithdrawCodeRequestDTO?) async throws
    func logout() async throws
    func me() async throws -> UserResponseDTO
    func name(_ request: UserNameRequestDTO) async throws
    func edit(_ request: EditUserRequestDTO) async throws
}

public final class DefaultUserDataSource: UserDataSource {
    private let provider: MoyaProvider<UserTarget>
    
    public init() {
        self.provider = MoyaProvider<UserTarget>.authorized()
    }
    
    public func leave(_ request: AppleWithdrawCodeRequestDTO?) async throws {
        let _ : BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            UserTarget.leave(request)
        )
    }
    
    public func logout() async throws {
        let _ : BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            UserTarget.logout
        )
    }
    
    public func me() async throws -> UserResponseDTO {
        let response : BaseResponseDTO<UserResponseDTO> = try await provider.request(
            UserTarget.me
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
            
        }
        
        return data
    }
    
    public func name(_ request: UserNameRequestDTO) async throws {
        let _ : BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            UserTarget.name(request)
        )
    }
    
    public func edit(_ request: EditUserRequestDTO) async throws {
        let _: BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            UserTarget.edit(request)
        )
    }
}

enum UserTarget {
    case leave(AppleWithdrawCodeRequestDTO?)
    case logout
    case me
    case name(UserNameRequestDTO)
    case edit(EditUserRequestDTO)
}

extension UserTarget: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseURL + "/api/v1/users")!
    }
    
    var path: String {
        switch self {
        case .leave: "/leave"
        case .logout: "/log-out"
        case .me: "/me"
        case .name: "/name"
        case .edit: ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .leave: .delete
        case .logout: .post
        case .me: .get
        case .name: .patch
        case .edit: .patch
        }
    }
    
    var task: Task {
        switch self {
        case .leave(let request):
            if let request {
                return .requestJSONEncodable(request)
            } else {
                return .requestPlain
            }
        case .logout, .me:
            return .requestPlain
        case .name(let request):
            return .requestJSONEncodable(request)
        case .edit(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var validationType: ValidationType { .successCodes }
}
