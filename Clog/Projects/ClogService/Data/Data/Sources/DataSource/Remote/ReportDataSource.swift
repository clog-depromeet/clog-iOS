//
//  ReportDataSource.swift
//  Data
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Networker
import Moya

public protocol ReportDataSource {
    func report(userId: String?) async throws -> ReportResponseDTO
}

public struct DefaultReportDataSource: ReportDataSource {
    
    private let provider: MoyaProvider<ReportTarget>
    
    public init() {
        self.provider = MoyaProvider<ReportTarget>.authorized()
    }
    
    public func report(userId: String?) async throws -> ReportResponseDTO {
        let response: BaseResponseDTO<ReportResponseDTO> = try await provider.request(
            ReportTarget.report(userId: userId)
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
            
        }
        
        return data
    }
}

enum ReportTarget {
    case report(userId: String?)
}

extension ReportTarget: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseURL + "/api/v1/reports")!
    }
    
    var path: String {
        switch self {
        case .report(let userId):
            if let userId = userId {
                return "/\(userId)"
            }
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .report:
            return .get
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var validationType: ValidationType { .successCodes }
}
