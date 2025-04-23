//
//  ErrorInfo.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

public struct ErrorInfo: Equatable {
    public let code: String
    public let error: Error?
    public let message: ErrorMessage?
    
    public static func == (lhs: ErrorInfo, rhs: ErrorInfo) -> Bool {
        guard lhs.code == rhs.code,
              lhs.message == rhs.message
        else {
            return false
        }
        
        // error 비교
        switch (lhs.error, rhs.error) {
        case (nil, nil):
            return true
        case (let l?, let r?):
            let lError = l as NSError
            let rError = r as NSError
            return lError.domain == rError.domain && lError.code == rError.code
        default:
            return false
        }
    }
}

public struct ErrorMessage: Codable, Hashable, Sendable {
    public let code: String?
    public let message: String?
    public let detail: String?
    public let name: String?
}
