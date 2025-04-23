//
//  AttemptDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Starlink

public protocol AttemptDataSource {
    func attempts(_ request: AttemptFilterRequestDTO) async throws -> [FolderAttemptResponseDTO]
    func attempt(_ attemptId: Int) async throws -> DetailAttemptResponseDTO
    func patch(id: Int, cragId: Int?, gradeId: Int?, unregisterGrade: Bool?, result: String?) async throws
    
    func delete(_ attemptId: Int) async throws
    func register(_ request: AttemptRequestDTO) async throws
}

public final class DefaultAttemptDataSource: AttemptDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func attempts(_ request: AttemptFilterRequestDTO) async throws -> [FolderAttemptResponseDTO] {
        let response: BaseResponseDTO<FolderResponseDTO> = try await provider.request(
            AttemptTarget.attempts(request: request)
        )
        
        guard let attempts = response.data?.attempts else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return attempts
    }
    
    public func attempt(_ attemptId: Int) async throws -> DetailAttemptResponseDTO {
        let response: BaseResponseDTO<DetailAttemptResponseDTO> = try await provider.request(AttemptTarget.detailAttempt(id: attemptId)
        )
        
        guard let attempt = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return attempt
    }
    
    public func patch(
        id: Int,
        cragId: Int? = nil,
        gradeId: Int? = nil,
        unregisterGrade: Bool? = nil,
        result: String? = nil
    ) async throws {
        let requestDTO = AttemptPatchRequestDTO(
            cragId: cragId,
            gradeId: gradeId,
            gradeUnregistered: unregisterGrade,
            status: result
        )
        
        let _: EmptyResponseDTO = try await provider.request(
            AttemptTarget.patch(id: id, requestDTO: requestDTO)
        )
    }
    
    public func delete(_ attemptId: Int) async throws {
        let _: EmptyResponseDTO = try await provider.request(AttemptTarget.delete(id: attemptId))
    }
    
    public func register(_ request: AttemptRequestDTO) async throws {
        let _: EmptyResponseDTO = try await provider.request(AttemptTarget.register(request))
    }
}

enum AttemptTarget {
    case attempts(request: AttemptFilterRequestDTO)
    case detailAttempt(id: Int)
    case patch(id: Int, requestDTO: AttemptPatchRequestDTO)
    case delete(id: Int)
    case register(AttemptRequestDTO)
}

extension AttemptTarget: EndpointType {
    var encoding: any StarlinkEncodable {
        switch self {
        case .patch, .register:
            Starlink.StarlinkJSONEncoding()
        default: Starlink.StarlinkURLEncoding()
        }
    }
    
   
    var baseURL: String {
        return Environment.baseURL + "/api/v1/attempts"
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
    
    var method: Starlink.Method {
        switch self {
        case .attempts, .detailAttempt: .get
        case .patch: .patch
        case .delete: .delete
        case .register: .post
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .attempts, .detailAttempt, .delete, .register: nil
        case .patch(_, let requestDTO): nil
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .attempts(let request): .encodable(request)
        case .detailAttempt, .delete: nil
        case .patch(_, let requestDTO): .encodable(requestDTO)
        case .register(let request): .encodable(request)
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .attempts, .detailAttempt, .delete, .register: nil
        case .patch: nil
        }
    }
}
