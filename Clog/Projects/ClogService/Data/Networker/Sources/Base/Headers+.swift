//
//  Headers+.swift
//  Networker
//
//  Created by Junyoung on 4/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Headers {
    public static let contentJson = ["Content-Type": "application/json"]
    
    public static let common = {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let currentTimeZone = TimeZone.current.identifier

        var headers: [String: String] = [
            "Content-Type": "application/json",
            "APP_VERSION": version,
            "APP_BUILD": buildVersion,
            "TIME_ZONE": currentTimeZone
        ]

        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            headers["APP_NAME"] = appName
        } else if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            headers["APP_NAME"] = appName
        }
        return headers
    }()
}
