//
//  CalendarDataSource.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Moya

public protocol CalendarDataSource {
    func calendars(_ request: YearMonthRequestDTO) async throws -> CalendarResponseDTO
}

public final class DefaultCalendarDataSource: CalendarDataSource {
    private typealias CalendarResponseType = BaseResponseDTO<CalendarResponseDTO>
    private let provider: MoyaProvider<CalendarTarget>
    
    public init() {
        self.provider = MoyaProvider<CalendarTarget>.authorized()
    }
    
    public func calendars(
        _ request: YearMonthRequestDTO
    ) async throws -> CalendarResponseDTO {
        let response: CalendarResponseType = try await provider.request(
            CalendarTarget.calendars(request)
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
        }
        
        return data
    }
}

enum CalendarTarget {
    case calendars(YearMonthRequestDTO)
}

extension CalendarTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.baseURL + "/api/v1/calendars")!
    }
    
    var path: String {
        switch self {
        case .calendars:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .calendars:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .calendars(let request):
            return request.toSafeRequestParameter()
        }
    }
}
