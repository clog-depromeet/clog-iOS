//
//  GradeDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Moya

public protocol GradeDataSource {
    func myGrades() async throws -> [FolderGradeResponseDTO]
    func cragGrades(cragId: Int) async throws -> [GradeResponseDTO]
}

public final class DefaultGradeDataSource: GradeDataSource {
    private let provider: MoyaProvider<GradeTarget>
    
    public init() {
        self.provider = MoyaProvider<GradeTarget>.authorized()
    }
    
    public func myGrades() async throws -> [FolderGradeResponseDTO] {
        let response: BaseResponseDTO<BaseContentsResponse<[FolderGradeResponseDTO], BaseMetaResponseDTO>> = try await provider.request(
            GradeTarget.myGrades
        )
        
        guard let myGrades = response.data?.contents else {
            throw NetworkError.decoding
        }
        
        return myGrades
    }
    
    public func cragGrades(cragId: Int) async throws -> [GradeResponseDTO] {
        let response: BaseResponseDTO<GradesResponseDTO> = try await provider.request(
            GradeTarget.cragGrades(id: cragId)
        )
        
        guard let grades = response.data?.grades else {
            throw NetworkError.decoding
        }
        
        return grades
    }
}

enum GradeTarget {
    case myGrades
    case cragGrades(id: Int)
}

extension GradeTarget: TargetType {
    var baseURL: URL {
        URL(string: Environment.baseURL + "/api/v1")!
    }
    
    var path: String {
        switch self {
        case .myGrades: 
            "/grades/me"
        case .cragGrades(let cragId):
            "/\(cragId)/grades"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myGrades, .cragGrades: .get
        }
    }
    
    var task: Task {
        return .requestPlain
    }
}
