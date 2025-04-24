//
//  CragDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink
import Networker

public protocol CragDataSource {
    func myCrags(cursor: Double?) async throws -> (crags: [FolderCragResponseDTO], meta: BaseMetaResponseDTO?)
    func nearByCrags(longitude: Double?, latitude: Double?, cursor: Double?, keyword: String?) async throws -> (crags: [FolderCragResponseDTO], meta: BaseMetaResponseDTO?)
}

public final class DefaultCragDataSource: CragDataSource {
    private typealias CragResponseType = BaseResponseDTO<BaseContentsResponse<[FolderCragResponseDTO], BaseMetaResponseDTO>>
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func myCrags(cursor: Double?) async throws -> (crags: [FolderCragResponseDTO], meta: BaseMetaResponseDTO?){
        let response: CragResponseType = try await provider.request(
            CragTarget.myCrags
        )
        
        guard let crags = response.data else {
            print("ERROR", #function)
            throw StarlinkError.inValidJSONData(nil)
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
            CragTarget.nearBy(longitude: longitude, latitude: latitude, cursor: cursor, keyword: keyword)
        )
        
        guard let crags = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        let meta = response.data?.meta
        
        return (crags.contents, meta)
    }
    
}

enum CragTarget {
    case myCrags
    case nearBy(longitude: Double?, latitude: Double?, cursor: Double?, keyword: String?)
}

extension CragTarget: EndpointType {
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkURLEncoding()
    }
    
    var baseURL: String {
        Environment.baseURL
    }
    
    var path: String {
        switch self {
        case .myCrags: "/api/v1/crags/me"
        case .nearBy: "/api/v1/crags/nearby"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .myCrags, .nearBy: .get
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .myCrags: return nil
        case .nearBy(let longitude, let latitude, let cursor, let keyword):
            var storage: [String: Any] = [:]
            if let cursor { storage["cursor"] = cursor }
            if let longitude { storage["longitude"] = longitude }
            if let latitude { storage["latitude"] = latitude }
            if let keyword { storage["keyword"] = keyword }
            let dictionary = Starlink.SafeDictionary<String, Any>(storage: storage)
            return Networker.ParameterType.dictionary(dictionary)
        }
    }
    
    var encodable: (any Encodable)? {
        switch self {
        case .myCrags, .nearBy: nil
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .myCrags, .nearBy: nil
        }
    }
}
