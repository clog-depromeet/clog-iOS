//
//  CragDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Moya

public protocol CragDataSource {
    func myCrags(cursor: Double?) async throws -> (crags: [FolderCragResponseDTO], meta: BaseMetaResponseDTO?)
    func nearByCrags(longitude: Double?, latitude: Double?, cursor: Double?, keyword: String?) async throws -> (crags: [FolderCragResponseDTO], meta: BaseMetaResponseDTO?)
}

public final class DefaultCragDataSource: CragDataSource {
    private typealias CragResponseType = BaseResponseDTO<BaseContentsResponse<[FolderCragResponseDTO], BaseMetaResponseDTO>>
    
    private let provider: MoyaProvider<CragTarget>
    
    public init() {
        self.provider = MoyaProvider<CragTarget>.authorized()
    }
    
    public func myCrags(cursor: Double?) async throws -> (crags: [FolderCragResponseDTO], meta: BaseMetaResponseDTO?){
        let response: CragResponseType = try await provider.request(
            CragTarget.myCrags
        )
        
        guard let crags = response.data else {
            print("ERROR", #function)
            throw NetworkError.decoding
        }
        
        let meta = response.data?.meta
        
        return (crags.contents, meta)
    }
    
    public func nearByCrags(
        longitude: Double?,
        latitude: Double?,
        cursor: Double?,
        keyword: String?
    ) async throws -> (crags: [FolderCragResponseDTO], meta: BaseMetaResponseDTO?) {
        let response: CragResponseType = try await provider.request(
            CragTarget.nearBy(
                longitude: longitude,
                latitude: latitude,
                cursor: cursor,
                keyword: keyword
            )
        )
        
        guard let crags = response.data else {
            throw NetworkError.decoding
        }
        let meta = response.data?.meta
        
        return (crags.contents, meta)
    }
    
}

enum CragTarget {
    case myCrags
    case nearBy(longitude: Double?, latitude: Double?, cursor: Double?, keyword: String?)
}

extension CragTarget: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseURL + "/api/v1/crags")!
    }
    
    var path: String {
        switch self {
        case .myCrags: "/me"
        case .nearBy: "/nearby"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myCrags, .nearBy: .get
        }
    }
    
    var task: Task {
        switch self {
        case .myCrags:
            return .requestPlain
        case .nearBy(let longitude, let latitude, let cursor, let keyword):
            let params: [String: Any?] = [
                "longitude": longitude,
                "latitude": latitude,
                "cursor": cursor,
                "keyword": keyword
            ]
            return .requestParameters(
                parameters: params.compactMapValues { $0 },
                encoding: URLEncoding.default
            )
        }
    }
}
