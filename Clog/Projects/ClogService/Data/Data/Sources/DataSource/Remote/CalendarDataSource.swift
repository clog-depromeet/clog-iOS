//
//  CalendarDataSource.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Starlink

public protocol CalendarDataSource {
    func calendars(_ request: YearMonthRequestDTO) async throws -> CalendarResponseDTO
}

public final class DefaultCalendarDataSource: CalendarDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func calendars(_ request: YearMonthRequestDTO) async throws -> CalendarResponseDTO {
        
        let response: BaseResponseDTO<CalendarResponseDTO> = try await provider.request(
            CalendarTarget.calendars(request)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
}

enum CalendarTarget {
    case calendars(YearMonthRequestDTO)
}

extension CalendarTarget: EndpointType {
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var path: String {
        switch self {
        case .calendars:
            return "/api/v1/calendars"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .calendars:
            return .get
        }
    }
    
    var parameters: ParameterType? {
        switch self {
        case .calendars(let request):
            return .encodable(request)
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .calendars(let request):
            return request
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
    
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkURLEncoding()
    }
}
