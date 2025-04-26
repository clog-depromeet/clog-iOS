//
//  AttemptDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Moya

public protocol AttemptDataSource {
    func attempts(_ request: AttemptFilterRequestDTO) async throws -> [FolderAttemptResponseDTO]
    func attempt(_ attemptId: Int) async throws -> DetailAttemptResponseDTO
    func patch(id: Int, cragId: Int?, gradeId: Int?, unregisterGrade: Bool?, result: String?) async throws
    
    func delete(_ attemptId: Int) async throws
    func register(_ request: AttemptRequestDTO) async throws
}

public final class DefaultAttemptDataSource: AttemptDataSource {
    private typealias FolderAttemptResponseType = BaseResponseDTO<[FolderAttemptResponseDTO]>
    private typealias DetailAttemptResponseType = BaseResponseDTO<DetailAttemptResponseDTO>
    
    private let provider: MoyaProvider<AttemptTarget>
    
    public init() {
        self.provider = MoyaProvider<AttemptTarget>.authorized()
    }
    
    public func attempts(
        _ request: AttemptFilterRequestDTO
    ) async throws -> [FolderAttemptResponseDTO] {
        let response: FolderAttemptResponseType = try await provider.request(
            .attempts(request: request)
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
        }
        
        return data
    }
    
    public func attempt(_ attemptId: Int) async throws -> DetailAttemptResponseDTO {
        let response: DetailAttemptResponseType = try await provider.request(
            .detailAttempt(id: attemptId)
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
        }
        
        return data
    }
    
    public func patch(
        id: Int,
        cragId: Int? = nil,
        gradeId: Int? = nil,
        unregisterGrade: Bool? = nil,
        result: String? = nil
    ) async throws {
        let request = AttemptPatchRequestDTO(
            cragId: cragId,
            gradeId: gradeId,
            gradeUnregistered: unregisterGrade,
            status: result
        )
        return try await provider.request(
            .patch(id: id, request: request)
        )
    }
    
    public func delete(_ attemptId: Int) async throws {
        try await provider.request(AttemptTarget.delete(id: attemptId))
    }
    
    public func register(_ request: AttemptRequestDTO) async throws {
        try await provider.request(AttemptTarget.register(request))
    }
}

enum AttemptTarget {
    case attempts(request: AttemptFilterRequestDTO)
    case detailAttempt(id: Int)
    case patch(id: Int, request: AttemptPatchRequestDTO)
    case delete(id: Int)
    case register(AttemptRequestDTO)
}

extension AttemptTarget: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseURL + "/api/v1/attempts")!
    }
    
    var path: String {
        switch self {
        case .attempts: ""
        case .detailAttempt(let id): "/\(id)"
        case .patch(let id, _): "/\(id)"
        case .delete(let id): "/\(id)"
        case .register: ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .attempts, .detailAttempt: .get
        case .patch: .patch
        case .delete: .delete
        case .register: .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .attempts(let request):
            let params: [String: Any?] = [
                "attemptStatus": request.attemptStatus,
                "cragId": request.cragId,
                "gradeId": request.gradeId
            ]
            
            return .requestParameters(
                parameters: params.compactMapValues { $0 },
                encoding: URLEncoding.default
            )
        case .detailAttempt, .delete:
            return .requestPlain
        case .patch(_, let requestDTO):
            return .requestJSONEncodable(requestDTO)
        case .register(let request):
            return .requestJSONEncodable(request)
        }
    }
}
