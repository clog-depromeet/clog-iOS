//
//  SessionErrorHandler.swift
//  Starlink
//
//  Created by saeng lin on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

extension Starlink {

    static func sessionErrorHandler(
        _ error: Error
    ) async -> StarlinkError {

        let starlinkError = StarlinkError(error: error)

        let errorInfo = starlinkError.errorInfo

        if starlinkError.errorInfo?.code == "401" {
            NotificationCenter.default.post(
                name: .didKickOut,
                object: nil,
                userInfo: nil
            )
        }

        switch errorInfo?.message?.code {
        case "C4010":
            if let errorInfoMessage = errorInfo?.message {
                NotificationCenter.default.post(
                    name: .didKickOut,
                    object: nil,
                    userInfo: ["ErrorInfoMessage": errorInfoMessage]
                )
            }
            break
        default:
            break
        }

        return starlinkError
    }
    private static func status401Handler(starlinkError: StarlinkError) async {

        guard starlinkError.errorInfo?.code == "401" else {
            let errorInfoMessage = starlinkError.errorInfo?.message
            NotificationCenter.default.post(
                name: .didKickOut,
                object: nil,
                userInfo: ["ErrorInfoMessage": errorInfoMessage]
            )
            return
        }
    }
}

extension Notification.Name {
    public static let didKickOut = Notification.Name("didKickOut")
}
