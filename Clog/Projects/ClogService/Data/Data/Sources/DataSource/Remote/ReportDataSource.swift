//
//  ReportDataSource.swift
//  Data
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink
import Networker

public protocol ReportDataSource {
    func report() async throws -> ReportResponseDTO
}

public struct DefaultReportDataSource: ReportDataSource {
    
    private let provider: Provider
    
    public init(with provider: Provider) {
        self.provider = provider
    }
    
    public func report() async throws -> ReportResponseDTO {
        let response: BaseResponseDTO<ReportResponseDTO> = try await provider.request(
            ReportTarget.report
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
}

enum ReportTarget {
    case report
}

extension ReportTarget: EndpointType {
    var baseURL: String {
        return Environment.baseURL + "/api/v1/reports"
    }
    
    var path: String {
        return ""
    }
    
    var method: Starlink.Method {
        switch self {
        case .report:
            return .get
        }
    }
    
    var parameters: ParameterType? {
        switch self {
        case .report:
            return .none
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .report:
            return .none
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
    
    var encoding: StarlinkEncodable {
        switch self {
        case .report:
            return Starlink.StarlinkURLEncoding()
        }
    }
}
