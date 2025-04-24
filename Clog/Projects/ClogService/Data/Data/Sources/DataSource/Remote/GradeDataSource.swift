//
//  GradeDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink
import Networker

public protocol GradeDataSource {
    func myGrades() async throws -> [FolderGradeResponseDTO]
    func cragGrades(cragId: Int) async throws -> [GradeResponseDTO]
}

public final class DefaultGradeDataSource: GradeDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func myGrades() async throws -> [FolderGradeResponseDTO] {
        let response: BaseResponseDTO<BaseContentsResponse<[FolderGradeResponseDTO], BaseMetaResponseDTO>> = try await provider.request(
            GradeTarget.myGrades
        )
        
        guard let myGrades = response.data?.contents else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return myGrades
    }
    
    public func cragGrades(cragId: Int) async throws -> [GradeResponseDTO] {
        let response: BaseResponseDTO<GradesResponseDTO> = try await provider.request(
            GradeTarget.cragGrades(id: cragId)
        )
        
        guard let grades = response.data?.grades else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return grades
    }
}

enum GradeTarget {
    case myGrades
    case cragGrades(id: Int)
}

extension GradeTarget: EndpointType {
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkURLEncoding()
    }
    
    var baseURL: String {
        Environment.baseURL
    }
    
    var path: String {
        switch self {
        case .myGrades: "/api/v1/grades/me"
        case .cragGrades(let cragId): "/api/v1/\(cragId)/grades"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .myGrades, .cragGrades: .get
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .myGrades, .cragGrades: nil
        }
    }
    
    var encodable: (any Encodable)? {
        switch self {
        case .myGrades, .cragGrades: nil
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .myGrades, .cragGrades: nil
        }
    }
    
    
}
