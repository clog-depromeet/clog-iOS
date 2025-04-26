//
//  StoriesDataSource.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Networker
import Moya

public protocol StoriesDataSource {
    func stories(_ storyId: Int) async throws -> StoryResponseDTO
    func problem(_ request: RegisterProblemRequestDTO) async throws -> RegisterProblemResponseDTO
    func summary(_ storyId: Int) async throws -> StorySummaryResponseDTO
    func memo(_ request: EditMemoRequestDTO) async throws
    func delete(_ storyId: Int) async throws
    func save(_ request: StoryRequestDTO) async throws -> SaveStoryResponseDTO
    func updateStatus(_ storyId: Int) async throws
}

public final class DefaultStoriesDataSource: StoriesDataSource {
    private let provider: MoyaProvider<StoriesTarget>
    
    public init() {
        self.provider = MoyaProvider<StoriesTarget>.authorized()
    }
    
    public func stories(_ storyId: Int) async throws -> StoryResponseDTO {
        let response: BaseResponseDTO<StoryResponseDTO> = try await provider.request(
            StoriesTarget.stories(storyId)
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
            
        }
        
        return data
    }
    
    public func summary(_ storyId: Int) async throws -> StorySummaryResponseDTO{
        let response: BaseResponseDTO<StorySummaryResponseDTO> = try await provider.request(
            StoriesTarget.summary(storyId)
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
            
        }
        
        return data
    }
    
    public func memo(_ request: EditMemoRequestDTO) async throws {
        let _: BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            StoriesTarget.memo(request)
        )
    }
    
    public func delete(_ storyId: Int) async throws {
        let _: BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            StoriesTarget.delete(storyId)
        )
    }
    
    public func save(_ request: StoryRequestDTO) async throws -> SaveStoryResponseDTO {
        let response: BaseResponseDTO<SaveStoryResponseDTO> = try await provider.request(
            StoriesTarget.save(request)
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
            
        }
        
        return data
    }
    
    public func problem(_ request: RegisterProblemRequestDTO) async throws -> RegisterProblemResponseDTO {
        let response: BaseResponseDTO<RegisterProblemResponseDTO> = try await provider.request(
            StoriesTarget.problem(request)
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
            
        }
        
        return data
    }
    
    public func updateStatus(_ storyId: Int) async throws {
        let _: BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            StoriesTarget.updateStatus(storyId)
        )
    }
}

enum StoriesTarget {
    case stories(Int)
    case problem(RegisterProblemRequestDTO)
    case summary(Int)
    case memo(EditMemoRequestDTO)
    case delete(Int)
    case save(StoryRequestDTO)
    case updateStatus(Int)
}

extension StoriesTarget: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseURL + "/api/v1/stories")!
    }
    
    var path: String {
        switch self {
        case .stories(let storyId):
            return "/\(storyId)"
        case .problem(let request):
            return "/\(request.storyId)/problems"
        case .summary(let storyId):
            return "/\(storyId)/summary"
        case .memo(let request):
            return "/\(request.storyId)/memo"
        case .delete(let storyId):
            return "/\(storyId)"
        case .updateStatus(let storyId):
            return "/\(storyId)/status/DONE"
        case .save:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .stories, .summary:
            return .get
        case .memo, .updateStatus:
            return .patch
        case .delete:
            return .delete
        case .save, .problem:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .stories, .summary, .delete, .updateStatus:
            return .requestPlain
        case .memo(let request):
            return .requestJSONEncodable(request)
        case .save(let request):
            return .requestJSONEncodable(request)
        case .problem(let request):
            return request.toSafeRequestParameter()
        }
    }
}
