//
//  Error.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

public enum StarlinkError: Swift.Error, Equatable {
    case inValidParams(ErrorInfo?)
    case inValidURLPath(ErrorInfo?)
    case nullPointStatusCode(ErrorInfo?)
    case nullPointData(ErrorInfo?)
    case inValidJSONData(ErrorInfo?)
    case inValidStatusCode(ErrorInfo?)
    case error(Error?)
    
    public init(error: Error) {
        if let starlinkError = error as? StarlinkError  {
            self = starlinkError
        } else {
            self = .error(error)
        }
    }

    public var errorInfo: ErrorInfo? {
        switch self {
        case .inValidParams(let info):
            return info
        case .inValidURLPath(let info):
            return info
        case .nullPointStatusCode(let info):
            return info
        case .nullPointData(let info):
            return info
        case .inValidJSONData(let info):
            return info
        case .inValidStatusCode(let info):
            return info
        case .error:
            return nil
        }
    }

    public static func == (lhs: StarlinkError, rhs: StarlinkError) -> Bool {
        switch (lhs, rhs) {
        case (.inValidURLPath(let lhsInfo), .inValidURLPath(let rhsInfo)):
            return lhsInfo == rhsInfo
            
        case (.nullPointStatusCode(let lhsInfo), .nullPointStatusCode(let rhsInfo)):
            return lhsInfo == rhsInfo
            
        case (.nullPointData(let lhsInfo), .nullPointData(let rhsInfo)):
            return lhsInfo == rhsInfo
            
        case (.inValidJSONData(let lhsInfo), .inValidJSONData(let rhsInfo)):
            return lhsInfo == rhsInfo
            
        case (.inValidStatusCode(let lhsInfo), .inValidStatusCode(let rhsInfo)):
            return lhsInfo == rhsInfo
            
            // .error(Error?) 케이스 비교 방식 (예시: NSError 기반)
        case (.error(let lhsError), .error(let rhsError)):
            switch (lhsError, rhsError) {
            case (nil, nil):
                return true
            case (let l?, let r?):
                let lError = l as NSError
                let rError = r as NSError
                return lError.domain == rError.domain && lError.code == rError.code
            default:
                return false
            }
            
        default:
            return false
        }
    }
}

extension StarlinkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .inValidParams(let info):
            return info?.message?.message ?? "❌ 유효하지 않은 Params 입니다."
        case .inValidURLPath(let info):
            return info?.message?.message ?? "❌ 유효하지 않은 URL 경로입니다."
        case .nullPointStatusCode(let info):
            return info?.message?.message ?? "❌ 상태 코드가 없습니다."
        case .nullPointData(let info):
            return info?.message?.message ?? "❌ 응답 데이터가 없습니다."
        case .inValidJSONData(let info):
            return info?.message?.message ?? "❌ 유효하지 않은 JSON 데이터입니다."
        case .inValidStatusCode(let info):
            return info?.message?.message ?? "❌ 유효하지 않은 상태 코드"
        case .error(let error):
            if let error = error {
                return error.localizedDescription
            } else {
                return "❓ 알 수 없는 오류가 발생했습니다."
            }
        }
    }
}
